require "rails_helper"
require "spec_helper"

RSpec.describe CheckpointsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:checkpoint) { create(:checkpoint) }
    let!(:another_checkpoint) do
      create(:checkpoint, issue_type: checkpoint.issue_type, checklist: checkpoint.checklist)
    end

    it "list checkpoints" do
      get checkpoints_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:checkpoints)
      expect(collection["data"].size).to eq(3)
    end

    it "show checkpoint" do
      get checkpoint_url(checkpoint), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:checkpoints)
    end
  end
end
