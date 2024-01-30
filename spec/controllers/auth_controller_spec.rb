require "spec_helper"
require "rails_helper"
require "./lib/json_web_token"

RSpec.describe AuthController, type: %i[request job] do
  before do
    handle_request_exceptions(true)
  end
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }

    it "sign in with password" do
      post sign_in_url,
           params: { auth: { email: superadmin.email, password: "123456" } }
      expect(response).to have_http_status(:created)
      expect(body_as_json).to include("auth")

      payload = JsonWebToken.decode(body_as_json["auth"])
      expect(superadmin.company_id).to eq(payload["cid"])
      expect(superadmin.id).to eq(payload["uid"])
    end

    it "sign in with wrong password" do
      post sign_in_url,
           params: { auth: { email: superadmin.email, password: "123466" } },
           as: :json
      errors = JSON.parse(response.body)["errors"].first
      expect(response).to have_http_status(:unauthorized)
      expect(errors["title"]).to eq("Unauthorized")
      expect(errors["detail"]).to eq("Les identifiants sont incorrects")
    end

    it "sign in with one time password" do
      post sign_in_otp_url,
           params: { auth: { email: superadmin.email, password: "123otp" } }
      expect(response).to have_http_status(:created)
      expect(body_as_json).to include("auth")

      payload = JsonWebToken.decode(body_as_json["auth"])
      expect(superadmin.id).to eq(payload["uid"])
    end

    it "request a one time password" do
      ActiveJob::Base.queue_adapter = :test
      post send_otp_url,
           params: { auth: { email: superadmin.email } }

      expect(response).to have_http_status(:created)
      expect(Postmark::Auth::SendOtpJob).to have_been_enqueued.at_least(:once)
    end

    it "cannot request a one time password with blank email" do
      superadmin.email = nil
      post send_otp_url,
           params: { auth: { email: superadmin.email } },
           as: :json
      errors = JSON.parse(response.body)["errors"].first
      expect(response).to have_http_status(:unprocessable_entity)
      expect(errors["detail"]).to eq("Le mot de passe à usage unique (OTP) n'a pas pu être généré")
    end
  end
end
