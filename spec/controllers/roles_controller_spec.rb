require "spec_helper"
require "rails_helper"

RSpec.describe RolesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let(:company) { create(:company) }
    let!(:sector) { create(:sector, company: company) }
    let(:user) { create(:user, company: company) }
    let(:role) { create(:role, name: "manager", user: user, sector: sector) }

    it "list roles" do
      get roles_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:roles)
      expect(collection["data"].size).to eq(1)
    end

    it "create role admin or superadmin" do
      post roles_url,
        headers: authorization_header(superadmin),
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
              }
            }
          }
        }
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:roles)
      assert_equal 1, User.find(user.id).roles_count
      
      other_user = create(:user)
      post roles_url,
        headers: authorization_header(superadmin),
        params: {
          data: {
            type: "roles",
            attributes: {
              name: "superadmin"
            },
            relationships: {
              user: {
                data: {
                  id: other_user.id,
                  type: "users"
                }
              }
            }
          }
        }
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:roles)
      assert_equal 1, User.find(user.id).roles_count
    end

    it "show role" do
      get role_url(role), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(role.name)
    end

    it "destroy role" do
      delete role_url(role), headers: authorization_header(superadmin)

      expect(response).to have_http_status(:no_content)
    end
  end
end
