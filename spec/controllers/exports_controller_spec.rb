require "rails_helper"
require "spec_helper"

RSpec.describe ExportsController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:export) { create(:export) }

    it "list exports" do
      get exports_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:exports)
      expect(collection["data"].size).to eq(1)
    end

    it "create export" do
      export = build(:export)

      expect {
        post exports_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "exports",
                 attributes: {
                 },
               },
             }
      }.to change { Export.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:exports)
    end

    it "show export" do
      get export_url(export), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:exports)
    end

    it "update export" do
      export = build(:export)

      patch export_url(export),
        headers: authorization_header(superadmin),
        params: {
          data: {
            id: export.id,
            type: "exports",
            attributes: {
              # Put your attributes here
            },
          },
        },
        as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
    end

    it "destroy export" do
      expect {
        delete export_url(export), headers: authorization_header(superadmin)
      }.to change { Export.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
