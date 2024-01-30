require "spec_helper"
require "rails_helper"

RSpec.describe AgenciesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:agency) { create(:agency) }

    it "list agencies" do
      get agencies_url, headers: authorization_header(superadmin), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:agencies)
      expect(collection["data"].size).to eq(1)
    end

    it "show agency" do
      get agency_url(agency), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(agency.name)
    end
  end
end
