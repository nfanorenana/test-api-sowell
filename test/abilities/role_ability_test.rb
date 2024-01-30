# frozen_string_literal: true

require "test_helper"

class RoleAbilityTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
    @user = create(:user, company: @company)
    @role = create(:role, company: @company)
  end

  context "as an anonymous I" do
    should "not crud" do
      ability = roleAbility.new(nil)

      assert ability.cannot?(:create, role)
      assert ability.cannot?(:read, role)
      assert ability.cannot?(:update, role)
      assert ability.cannot?(:destroy, role)
    end
  end

  context "as an user I" do
    should "cRud on my company roles" do
      assert @user.cannot?(:create, @role)
      assert @user.can?(:read, @role)
      assert @user.cannot?(:update, @role)
      assert @user.cannot?(:destroy, @role)
    end

    should "not crud on others companies roles" do
      other_company_role = create(:role, company: create(:company, name: "Other company"))
      assert @user.cannot?(:create, other_company_role)
      assert @user.cannot?(:read, other_company_role)
      assert @user.cannot?(:update, other_company_role)
      assert @user.cannot?(:destroy, other_company_role)
    end
  end

  context "as an user with admin role I" do
    should "CRUD on my company roles" do
      @user.add_role! :admin

      assert @user.can?(:create, @role)
      assert @user.can?(:read, @role)
      assert @user.can?(:update, @role)
      assert @user.can?(:destroy, @role)
    end

    should "not crud on other company roles" do
      @user.add_role! :admin
      other_company_user = create(:user, company: create(:company, name: "Other company"))
      other_company_role = create(:role, user: other_company_user)

      assert @user.cannot?(:create, other_company_role)
      assert @user.cannot?(:read, other_company_role)
      assert @user.cannot?(:update, other_company_role)
      assert @user.cannot?(:destroy, other_company_role)
    end
  end

  context "as an user with superadmin role I" do
    should "CRUD on any company role" do
      user = create(:user, email: "superadmin@email.com", company: nil)
      user.add_role! :superadmin

      assert user.can?(:create, role)
      assert user.can?(:read, role)
      assert user.can?(:update, role)
      assert user.can?(:destroy, role)
    end
  end
end
