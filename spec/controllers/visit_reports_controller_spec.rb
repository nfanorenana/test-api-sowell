require "rails_helper"
require "spec_helper"

RSpec.describe VisitReportsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:visit_report) { create(:visit_report) }

    it "list visit_reports" do
      get visit_reports_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:visit_reports)
      expect(collection["data"].size).to eq(1)
    end

    it "create visit_report" do
      expect do
        post visit_reports_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "visit_reports",
                 attributes: {
                   checkpoints: visit_report.checkpoints
                 },
                 relationships: {
                   visit_schedule: {
                     data: {
                       id: visit_report.visit_schedule_id,
                       type: "visit_schedules"
                     }
                   },
                   author: {
                     data: {
                       id: visit_report.author_id,
                       type: "authors"
                     }
                   }
                 }
               }
             }
      end.to change { VisitReport.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:visit_reports)
    end

    it "show visit_report" do
      get visit_report_url(visit_report), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:visit_reports)
    end
  end
end
