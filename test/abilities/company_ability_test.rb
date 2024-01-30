# frozen_string_literal: true

require "test_helper"

class CompanyAbilityTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
    @user = create(:user, company: @company)
  end

  context "as an anonymous I" do
    should "not crud" do
      ability = CompanyAbility.new(nil)

      assert ability.cannot?(:create, Company)
      assert ability.cannot?(:read, Company)
      assert ability.cannot?(:update, Company)
      assert ability.cannot?(:destroy, Company)
    end
  end

  context "as an authenticated user I" do
    should "cRud on my company" do
      assert @user.cannot?(:create, @company)
      assert @user.can?(:read, @company)
      assert @user.cannot?(:update, @company)
      assert @user.cannot?(:destroy, @company)
    end

    should "not crud on others companies" do
      other_company = create(:company, name: "other company")
      assert @user.cannot?(:create, other_company)
      assert @user.cannot?(:read, other_company)
      assert @user.cannot?(:update, other_company)
      assert @user.cannot?(:destroy, other_company)
    end
  end

  context "as an user with admin role I" do
    should "cRUd on my company" do
      @user.add_role! :admin

      assert @user.cannot?(:create, @company)
      assert @user.can?(:read, @company)
      assert @user.can?(:update, @company)
      assert @user.cannot?(:destroy, @company)
    end

    should "not crud on other companies" do
      @user.add_role! :admin

      other_company = create(:company, name: "other company")

      assert @user.cannot?(:create, other_company)
      assert @user.cannot?(:read, other_company)
      assert @user.cannot?(:update, other_company)
      assert @user.cannot?(:destroy, other_company)
    end
  end

  context "as an user with superadmin role I" do
    should "CRUD on any company" do
      user = create(:user, email: "superadmin@email.com", company: nil)
      user.add_role! :superadmin

      assert user.can?(:create, Company)
      assert user.can?(:read, Company)
      assert user.can?(:update, Company)
      assert user.can?(:destroy, Company)
    end
  end
end
