# frozen_string_literal: true

require "test_helper"

class SectorsControllerTest < ActionDispatch::IntegrationTest
  context "as an user with superadmin role I" do
    setup do
      @user = create(:user, email: "superadmin@email.com", company: nil)
      @user.add_role! :superadmin
      @company = create(:company)
      @sector = create(:sector, company: @company)
    end

    should "list sectors" do
      get sectors_url, headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_collection_response
    end

    should "create sector" do
      assert_difference("sector.count") do
        post sectors_url,
             headers: authorization_header(@user),
             params: {
               data: {
                 type: "sectors",
                 attributes: {
                   name: "a_name"
                 },
                 relationships: {
                   company: {
                     data: {
                       type: "companies",
                       id: @company.id.to_s
                     }
                   }
                 }
               }
             }, as: :json
      end

      assert_response 201
      assert_jsonapi_ressource_response
    end

    should "show sector" do
      get sector_url(@sector), headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_ressource_response
    end

    should "update sector" do
      patch sector_url(@sector),
            headers: authorization_header(@user),
            params: {
              data: {
                id: @sector.id.to_s,
                type: "sectors",
                attributes: attributes
              }
            }, as: :json
      assert_response 200
      assert_jsonapi_ressource_response
    end

    should "destroy sector" do
      assert_difference("sector.count", -1) do
        delete sector_url(@sector), headers: authorization_header(@user), as: :json
      end

      assert_response 204
    end
  end

  private

  def attributes
    { code: @sector.code, name: @sector.name }
  end
end
