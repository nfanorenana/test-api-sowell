require "spec_helper"
require "rails_helper"

RSpec.describe "Admin", type: :request do
  let(:company) { create(:company) }
  let(:admin) { create(:admin, company: company) }
  let(:other_company) { create(:company, name: "other company") }
  let(:other_place) { create(:place, company: other_company) }
  let!(:sector) { create(:sector, company: company) }
  let(:user) { create(:user, company: company) }
  let(:role) { create(:role, name: "manager", user: user, sector: sector) }

  context "an authenticated admin" do
    it "create sector" do
      new_sector = build(:sector, code: "S001")
      expect do
        post sectors_url,
             headers: authorization_header(admin),
             params: {
               data: {
                 type: "sectors",
                 attributes: {
                   name: new_sector.name,
                   code: new_sector.code
                 }
               }
             }
      end.to change { Sector.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:sectors)
      expect(resource["data"]).to have_attribute(:name).with_value(new_sector.name)
      expect(resource["data"]).to have_attribute(:code).with_value(new_sector.code)
    end

    it "create sector with unique code" do
      new_sector = build(:sector, code: "S001")
      post sectors_url,
           headers: authorization_header(admin),
           params: {
             data: {
               type: "sectors",
               attributes: {
                 name: new_sector.name,
                 code: new_sector.code
               }
             }
           }
      new_sector = build(:sector, code: "s001")
      post sectors_url,
           headers: authorization_header(admin),
           params: {
             data: {
               type: "sectors",
               attributes: {
                 name: new_sector.name,
                 code: new_sector.code
               }
             }
           }

      expect(response).to_not be_successful
      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expected_hash = {
        "code" => "unprocessable_entity",
        "status" => "422",
        "title" => "Validation Error",
        "detail" => "Code has already been taken"
      }

      expect(json["errors"]).to match([
                                        a_hash_including(expected_hash)
                                      ])
    end

    it "show sector" do
      get sector_url(sector), headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(sector.name)
    end

    it "update sector" do
      new_sector = build(:sector)

      patch sector_url(sector),
            headers: authorization_header(admin),
            params: {
              data: {
                id: sector.id,
                type: "sectors",
                attributes: {
                  name: new_sector.name,
                  code: new_sector.code
                }
              }
            },
            as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(new_sector.name)
      expect(resource["data"]).to have_attribute(:code).with_value(new_sector.code)
    end

    it "destroy sector" do
      expect do
        delete sector_url(sector), headers: authorization_header(admin)
      end.to change { Sector.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end

    it "can GET on /sectors?filter[agency_id]=AGENCY-ID" do
      other_sector = create(:sector_with_places, company: company, places_count: 2, name: "Second Sector")
      residences_ids = other_sector.places.pluck(:residence_id).join(",")
      agencies_ids = Residence.where(id: residences_ids).pluck(:agency_id).join(",")
      get "#{sectors_url}?filter[agency_id]=#{agencies_ids}", headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:sectors)
      expect(collection["data"].size).to eq(1)
    end

    it "can GET on /sectors?filter[residence_id]=RESIDENCE-ID" do
      other_sector = create(:sector_with_places, company: company, places_count: 2, name: "Second Sector")
      residences_ids = other_sector.places.pluck(:residence_id).join(",")
      get "#{sectors_url}?filter[residence_id]=#{residences_ids}", headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:sectors)
      expect(collection["data"].size).to eq(1)
    end

    it "can GET on /sector/SECTOR-ID?include=company&extra_fields[sectors]=places_count" do
      sector_with_places = create(:sector_with_places, company: company, places_count: 3)
      get "#{sector_url(sector_with_places)}?include=company&extra_fields[sectors]=places_count",
          headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:places_count).with_value(3)
    end

    it "can GET on /places?filter[agency_id]=AGENCY_ID_IN_HIS_COMPANY" do
      agency = create(:agency, company: admin.company)
      residence = create(:residence, agency: agency,  company: admin.company)
      create_list(:place, 3, residence: residence, company: admin.company)

      get "#{places_url}?filter[agency_id]=#{agency.id}&include=company",
          headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(3)
    end

    it "can GET on /places?filter[residence_id]=RESIDENCE_ID_IN_HIS_COMPANY" do
      residence = create(:residence, company: admin.company)
      create_list(:place, 3, residence: residence, company: admin.company)

      get "#{places_url}?filter[residence_id]=#{residence.id}&include=company",
          headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(3)
    end

    it "can GET on /places?filter[excluded_sector]=SECTOR_ID_IN_HIS_COMPANY" do
      sector = create(:sector_with_places, company: company, places_count: 2)
      other_sector = create(:sector_with_places, company: company, places_count: 1)

      get "#{places_url}?filter[excluded_sector]=#{sector.id}&include=company",
          headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      assert_equal other_sector.places.last.name, collection["data"][0]["attributes"]["name"]
    end

    it "can GET on /places?filter[excluded_sector]=SECTOR_ID_IN_ANOTHER_COMPANY with empty response" do
      other_company_sector = create(:sector_with_places, company: other_company)
      get "#{places_url}?filter[excluded_sector]=#{other_company_sector.id}&include=company",
          headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(0)
    end

    it "create role" do
      post roles_url,
      headers: authorization_header(admin),
      params: {
        data: {
          type: "roles",
          attributes: {
            name: "reporter"
          },
          relationships: {
            user: {
              data: {
                id: user.id,
                type: "users"
              }
            },
            sector: {
              data: {
                id: sector.id,
                type: "sectors"
              }
            }
          }
        }
      }

      expect(response).to have_http_status(:success)
      collection = body_as_json
      assert_equal 1, User.find(user.id).roles_count
    end

    it "can't create superadmin or admin role" do
      expect do
        post roles_url,
          headers: authorization_header(admin),
          params: {
            data: {
              type: "roles",
              attributes: {
                name: "superadmin"
              },
              relationships: {
                user: {
                  data: {
                    id: user.id,
                    type: "users"
                  }
                },
                sector: {
                  data: {
                    id: sector.id,
                    type: "sectors"
                  }
                }
              }
            }
          }
      end.to raise_error(CanCan::AccessDenied)

      expect do
        post roles_url,
          headers: authorization_header(admin),
          params: {
            data: {
              type: "roles",
              attributes: {
                name: "admin"
              },
              relationships: {
                user: {
                  data: {
                    id: user.id,
                    type: "users"
                  }
                },
                sector: {
                  data: {
                    id: sector.id,
                    type: "sectors"
                  }
                }
              }
            }
          }
      end.to raise_error(CanCan::AccessDenied)
    end

    it "read role" do 
      get roles_url, headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
    end

    it "destroy role" do 
      delete role_url(role), headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)
    end

    it "can GET /roles?filter[reporter_id]=REPORTER_ID" do 
      reporter = create(:reporter, company: company)
      get "#{roles_url}?filter[reporter_id]=#{reporter.id}", headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection_details = body_as_json
      expect(collection_details["data"].size).to eq(1)
      expect(collection_details["data"][0]["attributes"]["name"]).to eq("reporter")
    end

    it "can GET /roles?filter[manager_id]=MANAGER_ID" do 
      manager = create(:manager, company: company)
      get "#{roles_url}?filter[manager_id]=#{manager.id}", headers: authorization_header(admin), as: :json

      expect(response).to have_http_status(:success)

      collection_details = body_as_json
      expect(collection_details["data"].size).to eq(1)
      expect(collection_details["data"][0]["attributes"]["name"]).to eq("manager")
    end

    it "can POST on /sectors/SECTOR-ID/add-places" do
      sector_with_places = create(:sector_with_places, company: company, places_count: 3)

      places_to_add = [create(:place, company: company), create(:place, company: company)]

      post "/sectors/#{sector_with_places.id}/add-places", headers: authorization_header(admin), params: {
        data: places_to_add.each do |place|
          { type: "places", id: place.id }
        end
      }, as: :json

      expect(response).to have_http_status(:success)
      expect(sector_with_places.places.count).to eq(3 + places_to_add.count)
    end

    it "can DELETE on /sectors/SECTOR-ID/delete-places" do
      sector_with_places = create(:sector_with_places, company: company, places_count: 3)

      places_to_delete = [sector_with_places.places[0], sector_with_places.places[1]]

      delete "/sectors/#{sector_with_places.id}/delete-places", headers: authorization_header(admin), params: {
        data: places_to_delete.each do |place|
          { type: "places", id: place.id }
        end
      }, as: :json

      expect(response).to have_http_status(:success)
      expect(sector_with_places.places.count).to eq(3 - places_to_delete.count)
    end
  end
end
