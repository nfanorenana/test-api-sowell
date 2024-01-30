require "rails_helper"
require "spec_helper"

RSpec.describe VisitSchedulesController, type: :request do
  context "a superadmin" do
    subject(:superadmin) { create(:superadmin) }
    let!(:visit_schedule) { create(:visit_schedule) }

    it "list visit_schedules" do
      get visit_schedules_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:visit_schedules)
      expect(collection["data"].size).to eq(1)
    end

    it "show visit_schedule" do
      get visit_schedule_url(visit_schedule), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:visit_schedules)
    end
  end
end
