require "spec_helper"
require "rails_helper"

RSpec.describe LocationTypesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:location_type) { create(:location_type) }

    it "list location_types" do
      get location_types_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:location_types)
      expect(collection["data"].size).to eq(1)
    end

    it "show location_type" do
      get location_type_url(location_type), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(location_type.name)
    end
  end
end
