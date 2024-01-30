# frozen_string_literal: true

require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  context "as an user with superadmin role I" do
    setup do
      @user = create(:user, email: "superadmin@email.com", company: nil)
      @user.add_role! :superadmin
    end

    should "list users" do
      get users_url, headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_collection_response
    end

    should "create user" do
      assert_difference("User.count") do
        post users_url,
             headers: authorization_header(@user),
             params: {
               data: {
                 type: "users",
                 attributes: {
                   email: "user@email.com", fname: "fname", lname: "lname", password: "123456"
                 }
               }
             }, as: :json
      end
      assert_response 201
      assert_jsonapi_ressource_response
    end

    should "show user" do
      get user_url(@user), headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_ressource_response
    end

    should "update user" do
      attributes = { email: @user.email, fname: @user.fname, lname: @user.lname, password: "123456" }
      patch user_url(@user),
            headers: authorization_header(@user),
            params: {
              data: {
                id: @user.id.to_s,
                type: "users",
                attributes: attributes
              }
            }, as: :json
      assert_response 200
      assert_jsonapi_ressource_response
    end

    should "not destroy user" do
      delete user_url(@user), headers: authorization_header(@user), as: :json
      assert_response 404
    end
  end
end
