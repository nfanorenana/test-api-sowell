require "rails_helper"
require "spec_helper"

RSpec.describe IssueReportsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:issue_report) { create(:issue_report) }

    it "list issue_reports" do
      get issue_reports_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      expect(collection["data"].size).to eq(1)
    end

    it "create issue_report" do
      issue_report = create(:issue_report)

      expect do
        post issue_reports_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "issue_reports",
                 attributes: {
                   priority: issue_report.priority,
                   message: "Fake message"
                 },
                 relationships: {
                   company: {
                     data: {
                       id: issue_report.company_id,
                       type: "companies"
                     }
                   },
                   author: {
                     data: {
                       id: issue_report.author_id,
                       type: "authors"
                     }
                   },
                   place: {
                     data: {
                       id: issue_report.place_id,
                       type: "places"
                     }
                   },
                   issue_type: {
                     data: {
                       id: issue_report.issue_type_id,
                       type: "issue_types"
                     }
                   }
                 }
               }
             }
      end.to change { IssueReport.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:issue_reports)
    end

    it "show issue_report" do
      get issue_report_url(issue_report), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:issue_reports)
    end

    it "update issue_report" do
      new_issue_report = build(:issue_report)

      patch issue_report_url(issue_report),
            headers: authorization_header(superadmin),
            params: {
              data: {
                id: issue_report.id,
                type: "issue_reports",
                attributes: {
                  message: new_issue_report.message
                }
              }
            },
            as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
    end
  end
end
