require "spec_helper"
require "rails_helper"

RSpec.describe SectorsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:sector) { create(:sector) }

    it "list sectors" do
      get sectors_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:sectors)
      expect(collection["data"].size).to eq(1)
    end

    it "create sector" do
      new_sector = build(:sector)
      expect do
        post sectors_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "sectors",
                 attributes: {
                   name: new_sector.name
                 },
                 relationships: {
                   company: {
                     data: {
                       type: "companies",
                       id: sector.company_id
                     }
                   }
                 }
               }
             }
      end.to change { Sector.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:sectors)
      expect(resource["data"]).to have_attribute(:name).with_value(new_sector.name)
    end

    it "show sector" do
      get sector_url(sector), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(sector.name)
    end

    it "update sector" do
      newsector = build(:sector)

      patch sector_url(sector),
            headers: authorization_header(superadmin),
            params: {
              data: {
                id: sector.id,
                type: "sectors",
                attributes: {
                  name: newsector.name,
                  code: newsector.code
                }
              }
            },
            as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(newsector.name)
    end

    it "destroy sector" do
      expect do
        delete sector_url(sector), headers: authorization_header(superadmin)
      end.to change { Sector.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
