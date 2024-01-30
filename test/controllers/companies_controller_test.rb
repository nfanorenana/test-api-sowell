# frozen_string_literal: true

require "test_helper"

class CompaniesControllerTest < ActionDispatch::IntegrationTest
  context "as an user with superadmin role I" do
    setup do
      @company = create(:company)
      @user = create(:user, email: "superadmin@email.com", company: nil)
      @user.add_role! :superadmin
    end

    should "list companies" do
      get companies_url, headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_collection_response
    end

    should "create company" do
      assert_difference("Company.count") do
        post companies_url,
             headers: authorization_header(@user),
             params: {
               data: {
                 type: "companies",
                 attributes: {
                   name: "NewOne"
                 }
               }
             }, as: :json
      end
      assert_response 201
      assert_jsonapi_ressource_response
    end

    should "show company" do
      get company_url(@company), headers: authorization_header(@user), as: :json
      assert_response :success
      assert_jsonapi_ressource_response
    end

    should "update company" do
      patch company_url(@company),
            headers: authorization_header(@user),
            params: {
              data: {
                id: @company.id.to_s,
                type: "companies",
                attributes: attributes
              }
            }, as: :json
      assert_response 200
      assert_jsonapi_ressource_response
    end

    should "destroy company" do
      company = create(:company, name: "destroyMe")
      assert_difference("Company.count", -1) do
        delete company_url(company), headers: authorization_header(@user), as: :json
      end

      assert_response 204
    end
  end

  private

  def attributes
    { name: @company.name, logo_url: @company.logo_url, logo_base64: @company.logo_url }
  end
end
