require "spec_helper"
require "rails_helper"

RSpec.describe "Manager", type: :request do
  before do
    handle_request_exceptions(true)
  end

  context "an unauthenticated user" do
    let!(:company) { create(:company) }
    let!(:user) { create(:user, company: company) }

    it "can sign in if he request roles he owns" do
      user.add_role!(:admin)
      post sign_in_url,
           params: { auth: { email: user.email, password: "123456" } },
           headers: { "x-requested-roles": "admin" }
      expect(response).to have_http_status(:created)
      expect(body_as_json).to include("auth")
    end

    it "cannot sign in if he request roles he doesn't own" do
      user.add_role!(:admin)
      post sign_in_url,
           params: { auth: { email: user.email, password: "123456" } },
           headers: { "x-requested-roles": "manager" },
           as: :json
      errors = JSON.parse(response.body)["errors"].first
      expect(response).to have_http_status(:forbidden)
      expect(errors["detail"]).to eq("L'utilisateur est reconnu mais n'a pas les rôles requis")
    end
  end

  context "an authenticated manager" do
    let(:visit_report) { create(:visit_report) }
    let!(:second_visit_report) { create(:visit_report, visit_schedule: visit_report.visit_schedule) }

    let(:user) { visit_report.author }
    let!(:company) { user.company }
    let(:manager) { create(:manager, company: company) }
    let(:issue_report) { create(:issue_report, company: company) }
    let(:other_company) { create(:company, name: "Other company") }
    let(:other_company_issue_report) { create(:issue_report, company: other_company) }

    it "can see all visit reports in his company" do
      get visit_reports_url, headers: authorization_header(manager), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].first).to have_type(:visit_reports)
      # 20 is the default page size
      expect(collection["data"].size).to eq(20)
    end

    it "can see the details of a visit report in his company" do
      get "/visit_reports/#{visit_report['id']}?include=visit_schedule.place,visit_schedule.place.residence," \
          "visit_schedule.place.residence.agency,author,visit_schedule.checklist.checkpoints,issue_reports",
          headers: authorization_header(manager), as: :json
      collection_details = body_as_json

      expect(collection_details["data"]["id"]).to eq(visit_report["id"].to_s)
      expect(collection_details["data"]["attributes"]["checkpoints"]).to eq(visit_report["checkpoints"])
      expect(collection_details["data"]["attributes"]["checkpoints"].size).to eq(visit_report["checkpoints"].size)
      expect(collection_details["data"]["attributes"]["author_id"]).to eq(visit_report["author_id"])
      expect(collection_details["data"]["attributes"]["visit_schedule_id"]).to eq(visit_report["visit_schedule_id"])

      expect(included_types(collection_details["included"])).to include("visit_schedules", "users", "places",
                                                                        "checklists", "residences", "checkpoints", "agencies")
    end

    25.times do |index|
      let!(:"visit_report_#{index}") { create(:visit_report, visit_schedule: visit_report.visit_schedule) }
    end

    it "can get visit reports in his company and paginate" do
      get "/visit_reports?page[number]=1&page[size]=20&sort=-created_at&stats[total]=count&include=author,visit_schedule.checklist,visit_schedule.place.residence",
          headers: authorization_header(manager), as: :json

      collection_details = body_as_json
      expect(response).to have_http_status(:success)
      expect(collection_details["data"].size).to eq(20)
      expect(included_types(collection_details["included"])).to include("visit_schedules", "users", "places", "checklists",
                                                                        "residences")
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_manager) { create(:manager, company: other_company) }

    it "cannot get visit reports from another company and paginate" do
      get "/visit_reports?page[number]=1&page[size]=20&sort=-created_at&stats[total]=count&include=author,visit_schedule.checklist,visit_schedule.place.residence",
          headers: authorization_header(other_manager), as: :json

      collection_details = body_as_json
      expect(response).to have_http_status(:success)
      expect(collection_details["data"].size).to eq(0)
    end

    it "can get visit report details in his company" do
      get "/visit_reports/#{visit_report['id']}?include=author,issue_reports.place,visit_schedule.place.residence,visit_schedule.checklist.checkpoints",
          headers: authorization_header(manager), as: :json

      collection_details = body_as_json
      expect(collection_details["data"]["id"]).to eq(visit_report["id"].to_s)
      expect(collection_details["data"]["attributes"]["checkpoints"]).to eq(visit_report["checkpoints"])
      expect(collection_details["data"]["attributes"]["author_id"]).to eq(visit_report["author_id"])
      expect(collection_details["data"]["attributes"]["visit_schedule_id"]).to eq(visit_report["visit_schedule_id"])

      expect(included_types(collection_details["included"])).to include("visit_schedules", "users", "places", "checklists",
                                                                        "residences", "checkpoints")
    end

    it "cannot get visit report details from another company" do
      get "/visit_reports/#{visit_report['id']}?include=author,issue_reports.place,visit_schedule.place.residence,visit_schedule.checklist.checkpoints",
          headers: authorization_header(other_manager), as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:forbidden)
      json = JSON.parse(response.body)

      expected_hash = {
        "code" => "forbidden",
        "status" => "403",
        "title" => "Forbidden",
        "detail" => "Not authorized!"
      }

      expect(json["errors"]).to match([
                                        a_hash_including(expected_hash)
                                      ])
    end

    it "can list issue_reports on his company" do
      issues_report = create_list(:issue_report, 12, company: company)
      get "/issue_reports?page[number]=1&page[size]=10&filter[status]=pending&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(manager), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      expect(collection["data"].size).to eq(10)
    end

    let!(:manager_sector) do
      create(:sector_with_places, company: company, places_count: 3)
    end
    let!(:other_sector) do
      create(:sector_with_places, company: company, places_count: 2)
    end

    it "can list issue_reports on his sector" do
      # Creating issue reports for each sector
      manager_sector.places.each do |place|
        create_list(:issue_report, 4, company: company, place: place)
      end

      other_sector.places.each do |place|
        create_list(:issue_report, 2, company: company, place: place)
      end

      # Without sector
      get "/issue_reports?page[number]=1&page[size]=10&filter[status]=pending&filter[manager_id]=#{manager.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(manager), as: :json
      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection["data"].size).to eq(0)

      # With a sector
      manager.roles.update(sector_id: manager_sector.id)

      get "/issue_reports?page[number]=1&page[size]=20&filter[status]=pending&filter[manager_id]=#{manager.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(manager), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      # Number of places per scope (3) multiplied by the number of issue_reports per places (4) = 12
      expect(collection["data"].size).to eq(12)

      # With another sector
      manager.add_role!("manager", other_sector)

      get "/issue_reports?page[number]=1&page[size]=20&filter[status]=pending&filter[manager_id]=#{manager.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(manager), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      # Previous number of issue_reports = 12
      # + Number of places per scope (2) multiplied by the number of issue_reports per places (2) = 4
      expect(collection["data"].size).to eq(16)
    end

    it "cannot list issue_reports on other company" do
      issues_report_other_company = create_list(:issue_report, 6, company: other_company)
      get issue_reports_url, headers: authorization_header(manager), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end

    it "can see the details of an issue report in his company" do
      get issue_report_url(issue_report) + "?include=place.residence,author,issue_type.location_type",
          headers: authorization_header(manager), as: :json

      expect(response).to have_http_status(:success)
      resource = body_as_json
      issue_report_data = resource["data"]
      expect(issue_report_data["id"]).to eq(issue_report["id"].to_s)
      expect(issue_report_data["attributes"]["message"]).to eq(issue_report["message"])
      expect(issue_report_data["attributes"]["author_id"]).to eq(issue_report["author_id"])
      expect(issue_report_data["attributes"]["visit_schedule_id"]).to eq(issue_report["visit_schedule_id"])
      expect(resource).to behave_like_a_jsonapi_resource
      expect(issue_report_data).to have_type(:issue_reports)
    end

    it "cannot see the details of an issue report in other company" do
      get issue_report_url(other_company_issue_report) + "?include=place.residence,author,issue_type.location_type",
          headers: authorization_header(manager), as: :json

      errors = JSON.parse(response.body)["errors"].first
      expect(response).to have_http_status(:forbidden)
    end
  end
end

private

def included_types(collection)
  collection.map { |included| included["type"] }
end
