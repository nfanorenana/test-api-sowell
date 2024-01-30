require "spec_helper"
require "rails_helper"

RSpec.describe "Reporter", type: :request do
  context "an authenticated reporter" do
    let!(:place) { create(:place) }
    let(:user) { create(:user, company: place.company) }
    let!(:checklist) { create(:checklist, company: place.company) }
    let!(:visit_schedule) { create(:visit_schedule, checklist: checklist) }

    let(:issue_report) { create(:issue_report, company: place.company) }
    let!(:spot) { create(:spot, place: issue_report.place) }
    let(:issue_report_with_spot) do
      create(:issue_report, spot: spot, place: issue_report.place, company: issue_report.company)
    end

    let(:reporter) { create(:reporter, company: issue_report.company) }
    let(:sector) { reporter.roles.first.sector }
    let(:company) { reporter.company }
    let(:other_company) { create(:company, name: "Other company") }
    let(:other_company_issue_report) { create(:issue_report, company: other_company) }

    let(:visit_report) { create(:visit_report, visit_schedule: visit_schedule) }
    let(:visit_report_reporter) { create(:reporter, company: visit_schedule.place.company) }
    let(:issue_type) { create(:issue_type, company: user.company) }
    let(:checkpoint) { create(:checkpoint, issue_type: issue_type) }

    let(:visit_report_in_other_company) { create(:visit_report) }

    it "can GET on /residences?filter[agency_id]=AGENCY-ID&include=company" do
      get "#{residences_url(place.residence_id)}?filter[agency_id]=#{place.residence.agency_id}&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
    end

    it "can GET on /residences?filter[has_scheduled_visit]=true&include=company" do
      get "#{residences_url}?filter[has_scheduled_visit]=true&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
    end

    it "can GET on /residences?filter[reporter_id]=REPORTER-ID" do
      get "#{residences_url}?filter[reporter_id]=#{reporter.id}&include=company",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)

      # TODO: add data verification
    end

    it "can GET on /residences?filter[has_scheduled_visit]=false&include=company" do
      get "#{residences_url}?filter[has_scheduled_visit]=false&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(7)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
    end

    it "can GET on /residences?filter[agency_id]=AGENCY-ID&filter[has_scheduled_visit]=true&include=company" do
      get "#{residences_url}?filter[agency_id]=#{place.residence.agency_id}&filter[has_scheduled_visit]=true&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end

    it "can GET on /places?filter[residence_id]=RESIDENCE-ID&include=company,spots" do
      get "#{places_url}?filter[residence_id]=#{issue_report.place.residence_id}&include=company,spots",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(included_types(collection["included"])).to eq(%w[companies spots])
    end

    it "can GET on /places?filter[has_scheduled_visit]=true&include=company,spots,visit_schedules" do
      get "#{places_url}?filter[has_scheduled_visit]=true&include=company,visit_schedules",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
      expect(included_types(collection["included"])).to eq(%w[companies visit_schedules])
    end

    it "can GET on /places?filter[reporter_id]=REPORTER-ID" do
      sector.places << place

      # Without sector_ids extra field
      get "#{places_url}?filter[reporter_id]=#{reporter.id}&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["data"].first["attributes"]["sector_ids"]).to be_nil

      # Without sector_ids extra field
      get "#{places_url}?filter[reporter_id]=#{reporter.id}&include=company&extra_fields[places]=sector_ids",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["data"].first["attributes"]["sector_ids"]).to eq(place.sectors.ids)
    end

    it "can GET on /places?filter[has_scheduled_visit]=false&include=company" do
      get "#{places_url}?filter[has_scheduled_visit]=false&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(7)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
    end

    it "can GET on /places?filter[residence_id]=RESIDENCE-ID&filter[has_scheduled_visit]=true&include=company" do
      get "#{places_url}?filter[residence_id]=#{place.residence_id}&filter[has_scheduled_visit]=true&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end

    it "can GET on /places?filter[updated_since]=DD-MM-YYYY-hh-mm-ss" do
      travel(-1.day) do
        create_list(:place, 2, company: reporter.company)
      end

      past_datetime = DateTime.now - 7.days
      get "#{places_url}?filter[updated_since]=#{past_datetime.strftime('%d-%m-%Y-%H-%M-%S')}",
          headers: authorization_header(reporter), as: :json

      collection_details = body_as_json

      # Fetches all the previous created places + the 2 created above
      expect(collection_details["data"].size).to eq(10)
      collection_details["data"].each do |place|
        expect(place["attributes"]["updated_at"].to_datetime).to be >= past_datetime
      end

      # Only one place is updated in the future
      travel(+2.days) do
        place_in_future = Place.where(company_id: reporter.company_id).last
        place_in_future.update!(name: "Place updated in the future")
      end

      # We set a datetime slightly after the present time to exclude places created on the present
      future_datetime = DateTime.current + 2.hours
      get "#{places_url}?filter[updated_since]=#{future_datetime.strftime('%d-%m-%Y-%H-%M-%S')}",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)

      collection_details = body_as_json

      # Only one place is fetched
      expect(collection_details["data"].size).to eq(1)
      collection_details["data"].each do |place|
        expect(place["attributes"]["updated_at"].to_datetime).to be >= future_datetime
      end
    end

    it "can GET on /places?filter[sector_id]=SECTOR-ID" do
      get "#{places_url}?filter[sector_id]=#{sector.id}",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(sector.places.count).to eq(0)
      expect(collection["data"].size).to eq(sector.places.count)

      sector.places << place

      get "#{places_url}?filter[sector_id]=#{sector.id}",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(sector.places.count).to eq(1)
      expect(collection["data"].size).to eq(sector.places.count)
    end

    it "can GET on /agencies?filter[has_scheduled_visit]=true&include=company" do
      get "#{agencies_url}?filter[has_scheduled_visit]=true&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
    end

    it "can GET /visit_schedules?filter[place_id]=1&include=place,checklist" do
      get "#{visit_schedules_url}?filter[place_id]=#{visit_schedule.place.id}&include=place,checklist",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection["data"].size).to eq(1)
      expect(collection["included"][0]["id"]).to eq(visit_schedule.place.id.to_s)
    end

    it "can GET on /agencies?filter[has_scheduled_visit]=false&include=company" do
      get "#{agencies_url}?filter[has_scheduled_visit]=false&include=company",
          headers: authorization_header(user), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(7)
      expect(collection["included"][0]["id"]).to eq(place.company_id.to_s)
    end

    it "can GET on /agencies?filter[reporter_id]=REPORTER-ID" do
      get "#{agencies_url}?filter[reporter_id]=#{reporter.id}&include=company",
          headers: authorization_header(user), as: :json
      expect(response).to have_http_status(:success)
      # TODO: add data verification
    end

    it "can POST /visit_reports in his company" do
      expect do
        post visit_reports_url,
             headers: authorization_header(visit_report_reporter),
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
      end.to change { VisitReport.count }.by(2)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:visit_reports)
    end

    it "cannot POST /visit_reports in other company" do
      expect do
        post visit_reports_url,
             headers: authorization_header(reporter),
             params: {
               data: {
                 type: "visit_reports",
                 attributes: {
                   checkpoints: visit_report_in_other_company.checkpoints
                 },
                 relationships: {
                   visit_schedule: {
                     data: {
                       id: visit_report_in_other_company.visit_schedule_id,
                       type: "visit_schedules"
                     }
                   },
                   author: {
                     data: {
                       id: visit_report_in_other_company.author_id,
                       type: "authors"
                     }
                   }
                 }
               }
             }
      end.to raise_error(CanCan::AccessDenied)
    end

    it "can create an issue_report related to a visit_report" do
      expect do
        post issue_reports_url,
             headers: authorization_header(user),
             params: {
               data: {
                 type: "issue_reports",
                 attributes: {
                   priority: "low",
                   message: "Fake message"
                 },
                 relationships: {
                   company: {
                     data: {
                       id: user.company_id,
                       type: "companies"
                     }
                   },
                   author: {
                     data: {
                       id: user.id,
                       type: "authors"
                     }
                   },
                   place: {
                     data: {
                       id: visit_schedule.place_id,
                       type: "places"
                     }
                   },
                   issue_type: {
                     data: {
                       id: issue_type.id,
                       type: "issue_types"
                     }
                   },
                   checkpoint: {
                     data: {
                       id: checkpoint.id,
                       type: "checkpoints"
                     }
                   },
                   visit_report: {
                     data: {
                       id: visit_report.id,
                       type: "visit_reports"
                     }
                   }
                 }
               }
             }
      end.to change { IssueReport.count }.by(1)
      expect(response).to have_http_status(:created)
      collection_details = body_as_json
      expect(included_types(collection_details["included"])).to eq(%w[companies issue_types places users
                                                                      visit_reports checkpoints])
      expect(collection_details["included"].last["id"]).to eq(checkpoint.id.to_s)
    end

    # FIXME: Add cases when the user cannot GET on resources
    it "can POST /issue_reports on his company" do
      # Without a spot
      issue_report = create(:issue_report)
      reporter = create(:reporter, company: issue_report.company)
      expect do
        post issue_reports_url,
             headers: authorization_header(reporter),
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

      # With spot
      spot = create(:spot, place: issue_report.place)
      issue_report_with_spot = create(:issue_report, spot: spot, place: issue_report.place,
                                                     company: issue_report.company)
      reporter = create(:reporter, company: issue_report_with_spot.company)
      expect do
        post issue_reports_url,
             headers: authorization_header(reporter),
             params: {
               data: {
                 type: "issue_reports",
                 attributes: {
                   priority: issue_report_with_spot.priority,
                   message: "Fake message"
                 },
                 relationships: {
                   company: {
                     data: {
                       id: issue_report_with_spot.company_id,
                       type: "companies"
                     }
                   },
                   author: {
                     data: {
                       id: issue_report_with_spot.author_id,
                       type: "authors"
                     }
                   },
                   place: {
                     data: {
                       id: issue_report_with_spot.place_id,
                       type: "places"
                     }
                   },
                   issue_type: {
                     data: {
                       id: issue_report_with_spot.issue_type_id,
                       type: "issue_types"
                     }
                   },
                   spot: {
                     data: {
                       id: issue_report_with_spot.spot_id,
                       type: "spots"
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
      expect(included_types(resource["included"])).to eq(%w[companies issue_types places users spots])
      expect(resource["included"][4]["type"]).to eq("spots")
      expect(resource["included"][4]["id"]).to eq(spot.id.to_s)
    end

    let!(:reporter_sector) { create(:sector_with_places, company: company, places_count: 3, name: "First Sector") }
    let!(:other_sector) { create(:sector_with_places, company: company, places_count: 2, name: "Second Sector") }

    it "can list issue_reports on his sector" do
      # Creating issue reports for each sector
      reporter_sector.places.each do |place|
        create_list(:issue_report, 4, company: company, place: place)
      end

      other_sector.places.each do |place|
        create_list(:issue_report, 2, company: company, place: place)
      end

      # Without sector
      get "/issue_reports?page[number]=1&page[size]=10&filter[status]=pending&filter[reporter_id]=#{reporter.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection["data"].size).to eq(0)

      # With a sector
      reporter.roles.update(sector_id: reporter_sector.id)

      get "/issue_reports?page[number]=1&page[size]=20&filter[status]=pending&filter[reporter_id]=#{reporter.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      # Number of places per scope (3) multiplied by the number of issue_reports per places (4) = 12
      expect(collection["data"].size).to eq(12)

      # With another sector
      reporter.add_role!("reporter", other_sector)

      get "/issue_reports?page[number]=1&page[size]=20&filter[status]=pending&filter[reporter_id]=#{reporter.id}&sort=-updated_at&stats[total]=count&include=place,place.residence,issue_type,issue_type.location_type,author",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:issue_reports)
      # Previous number of issue_reports = 12
      # + Number of places per scope (2) multiplied by the number of issue_reports per places (2) = 4
      expect(collection["data"].size).to eq(16)
    end

    it "can see the details of an issue report in his company" do
      # With a spot
      get issue_report_url(issue_report_with_spot) + "?include=place.residence,author,issue_type.location_type,spot",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:issue_reports)
      collection_details = body_as_json
      expect(included_types(collection_details["included"])).to eq(%w[issue_types places users spots
                                                                      location_types residences])
      expect(collection_details["included"][3]["type"]).to eq("spots")
      expect(collection_details["included"][3]["id"]).to eq(spot.id.to_s)

      # Without a spot
      get issue_report_url(issue_report) + "?include=place.residence,author,issue_type.location_type,spot",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:issue_reports)
      collection_details = body_as_json
      expect(included_types(collection_details["included"])).to eq(%w[issue_types places users location_types
                                                                      residences])
    end

    it "cannot see the details of an issue report in other company" do
      expect do
        get issue_report_url(other_company_issue_report) + "?include=place.residence,author,issue_type.location_type",
            headers: authorization_header(reporter), as: :json

        errors = JSON.parse(response.body)["errors"].first
        expect(response).to have_http_status(:forbidden)
      end.to raise_error(CanCan::AccessDenied)
    end

    it "can GET on /sectors?filter[reporter_id]=REPORTER-ID" do
      company = create(:company)
      reporter = create(:user, company: company)
      # Without sector
      get "/sectors?filter[reporter_id]=#{reporter.id}",
          headers: authorization_header(reporter), as: :json
      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection["data"].size).to eq(0)

      # With a sector
      reporter.add_role!(:reporter, create(:sector, company: reporter.company))

      get "/sectors?filter[reporter_id]=#{reporter.id}",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:sectors)
      expect(collection["data"].size).to eq(1)

      # With manager role
      reporter.roles.update(name: "manager")
      get "/sectors?filter[reporter_id]=#{reporter.id}",
          headers: authorization_header(reporter), as: :json

      expect(response).to have_http_status(:success)
      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end

    it "can POST on /issue_reports/ID/talks" do
      stored_talks_count = issue_report.talks.count
      post "/issue_reports/#{issue_report.id}/talks", headers: authorization_header(reporter),
                                                      params: { talks: { message: "Test message" } }

      expect(response).to have_http_status(:success)

      talks = JSON.parse(response.body)["talks"]

      expect(talks.length).to eq(1)
      expect(talks[0]["id"]).to eq("#{issue_report.id}_#{stored_talks_count}")
      expect(talks[0]["message"]).to eq("Test message")
      expect(talks[0]["author"]["id"]).to eq(reporter.id)
      expect(talks[0]["author"]["name"]).to eq(reporter.full_name)

      # One more talk
      post "/issue_reports/#{issue_report.id}/talks", headers: authorization_header(reporter),
                                                      params: { talks: { message: "Test new message" } }

      expect(response).to have_http_status(:success)

      talks = JSON.parse(response.body)["talks"]

      expect(talks.length).to eq(2)
    end

    it "cannot POST on /issue_reports/ID/talks with blank params" do
      expect do
        post "/issue_reports/#{issue_report.id}/talks", headers: authorization_header(reporter), params: {}
      end.to raise_error(ActionController::BadRequest)
    end

    it "cannot POST on /issue_reports/ID/talks with invalid params" do
      post "/issue_reports/#{issue_report.id}/talks", headers: authorization_header(reporter),
                                                      params: { talks: { message: ["not the expected format"] } }

      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.status).to eq(422)
    end
    it "can POST on /issue_reports/id/images with multiple files" do
      files = []
      3.times do |_index|
        file = upload_file("photo.jpg", "image/jpg")
        files.push(file)
      end

      post "/issue_reports/#{issue_report.id}/images",
           headers: authorization_header(reporter),
           params: {
             file: files
           }

      expect(response).to have_http_status(:created)
      expect(Cloudinary::TmpFiles::CreatedJob).to have_been_enqueued.at_least(3).times

      resource = body_as_json
      expect(resource["id"]).to eq(issue_report.id.to_s)
      expect(resource["received"]).to eq(files.count)
    end

    it "cannot POST on /issue_reports/id/images with more than 3 files" do
      files = []
      4.times do
        file = upload_file("photo.jpg", "image/jpg")
        files.push(file)
      end

      expect do
        post "/issue_reports/#{issue_report.id}/images",
             headers: authorization_header(reporter),
             params: {
               file: files
             }
      end.to raise_error(Rescueable::UnprocessableEntity)
    end

    it "cannot POST on /issue_reports/id/images with an unencapsulated file" do
      # NOTE: the file here is NOT inside an array
      expect do
        post "/issue_reports/#{issue_report.id}/images",
             headers: authorization_header(reporter),
             params: {
               file: upload_file("photo.jpg", "image/jpg")
             }
      end.to raise_error(Rescueable::UnprocessableEntity)
    end

    it "cannot POST on /issue_reports/id/images with an empty list of files" do
      expect do
        post "/issue_reports/#{issue_report.id}/images",
             headers: authorization_header(reporter),
             params: {
               file: []
             },
             as: :json
      end.to raise_error(Rescueable::UnprocessableEntity)
    end

    it "cannot POST on /issue_reports/id/images TWICE or more" do
      issue_report.imgs = ["fake.url"]
      issue_report.save

      # NOTE: The issue report in this example already has an URL
      # in real cases it must mean that we already called the upload endpoint once

      file0 = upload_file("photo.jpg", "image/jpg")
      expect do
        post "/issue_reports/#{issue_report.id}/images",
             headers: authorization_header(reporter),
             params: {
               file: [file0]
             }
      end.to raise_error(Rescueable::UnprocessableEntity)
    end

    it "can GET on /visit_schedules?filter[due_until]=YYYY-MM-DD" do
      get "#{visit_schedules_url}?filter[due_until]=#{(Date.today + 1.week).strftime('%F')}&include=place,checklist",
          headers: authorization_header(user), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)

      get "#{visit_schedules_url}?filter[due_until]=#{(Date.today + 2.months).strftime('%F')}&include=place,checklist",
          headers: authorization_header(user), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
    end

    it "can GET on /visit_schedules?filter[checklister_id]=CHECKLISTER-ID" do
      get "#{visit_schedules_url}?filter[checklister_id]=1&include=place,checklist",
          headers: authorization_header(user), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end
  end
end

private

def included_types(collection)
  collection.map { |included| included["type"] }
end
