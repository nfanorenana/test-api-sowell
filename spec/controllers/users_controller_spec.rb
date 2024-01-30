require "spec_helper"
require "rails_helper"

RSpec.describe UsersController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }

    it "list users" do
      get users_url, headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:users)
      expect(collection["data"].size).to eq(1)
    end

    it "create user" do
      user = build(:user)

      expect {
        post users_url,
             headers: authorization_header(superadmin),
             params: {
               data: {
                 type: "users",
                 attributes: {
                   email: user.email,
                   fname: user.fname,
                   lname: user.lname,
                   password: user.password,
                 },
               },
             }
      }.to change { User.count }.by(2)
      expect(response).to have_http_status(:created)

      resource = body_as_json
      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_type(:users)
      expect(resource["data"]).to have_attribute(:fname).with_value(user.fname)
      expect(resource["data"]).to have_attribute(:status).with_value("active")
    end

    it "show user" do
      get user_url(superadmin), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:fname).with_value(superadmin.fname)
    end

    it "update user" do
      newuser = build(:user)

      patch user_url(superadmin),
            headers: authorization_header(superadmin),
            params: {
              data: {
                id: superadmin.id,
                type: "users",
                attributes: {
                  email: newuser.email,
                  fname: newuser.fname,
                  lname: newuser.lname,
                  password: newuser.password,
                },
              },
            },
            as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:fname).with_value(newuser.fname)
    end

    describe "route for deleting user", type: :routing do
      it "not destroy user" do
        expect(:delete => "/users/#{superadmin.id}").not_to be_routable
      end
    end
  end
end
