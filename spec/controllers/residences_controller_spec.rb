require "spec_helper"
require "rails_helper"

RSpec.describe ResidencesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:residence) { create(:residence) }

    it "list residences" do
      get residences_url, headers: authorization_header(superadmin), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:residences)
      expect(collection["data"].size).to eq(1)
    end

    it "show residence" do
      get residence_url(residence), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(residence.name)
    end
  end
end
