require "rails_helper"
require "spec_helper"

RSpec.describe ChecklistsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:checklist) { create(:checklist) }

    it "list checklists" do
      get checklists_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:checklists)
      expect(collection["data"].size).to eq(1)
    end

    it "show checklist" do
      get checklist_url(checklist), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:checklists)
    end
  end
end
