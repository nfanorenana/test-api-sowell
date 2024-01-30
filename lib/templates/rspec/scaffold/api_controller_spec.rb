require "rails_helper"
require "spec_helper"

<% module_namespacing do -%>
RSpec.describe <%= controller_class_name %>Controller, <%= type_metatag(:request) %> do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:<%= singular_table_name %>) { create(:<%= singular_table_name %>) }

    it "list <%= index_helper %>" do
      get <%= index_helper %>_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:<%= index_helper %>)
      expect(collection["data"].size).to eq(1)
    end

    it "create <%= singular_table_name %>" do
      <%= singular_table_name %> = build(:<%= singular_table_name %>)

      expect {
        post <%= index_helper %>_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "<%= plural_table_name %>",
                 attributes: {
                 },
               },
             }
      }.to change { <%= class_name %>.count }.by(1)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:<%= plural_table_name %>)
    end

    it "show <%= singular_table_name %>" do
      get <%= singular_table_name %>_url(<%= singular_table_name %>), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:<%= plural_table_name %>)
    end

    it "update <%= singular_table_name %>" do
      <%= singular_table_name %> = build(:<%= singular_table_name %>)

      patch <%= singular_table_name %>_url(<%= singular_table_name %>),
        headers: authorization_header(superadmin),
        params: {
          data: {
            id: <%= singular_table_name %>.id,
            type: "<%= plural_table_name %>",
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

    it "destroy <%= singular_table_name %>" do
      expect {
        delete <%= singular_table_name %>_url(<%= singular_table_name %>), headers: authorization_header(superadmin)
      }.to change { <%= class_name %>.count }.by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
<% end -%>