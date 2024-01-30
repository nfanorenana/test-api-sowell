require "rails_helper"
require "spec_helper"

RSpec.describe IssueTypesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:issue_type) { create(:issue_type) }

    it "list issue_types" do
      get issue_types_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_types)
      expect(collection["data"].size).to eq(1)
    end

    it "show issue_type" do
      get issue_type_url(issue_type), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:issue_types)
    end
  end
end
