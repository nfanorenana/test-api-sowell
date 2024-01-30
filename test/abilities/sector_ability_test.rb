# frozen_string_literal: true

require "test_helper"

class SectorAbilityTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
    @user = create(:user, company: @company)
    @sector = create(:sector, company: @company)
  end

  context "as an anonymous I" do
    should "not crud" do
      ability = sectorAbility.new(nil)

      assert ability.cannot?(:create, sector)
      assert ability.cannot?(:read, sector)
      assert ability.cannot?(:update, sector)
      assert ability.cannot?(:destroy, sector)
    end
  end

  context "as an user I" do
    should "cRud on my company sectors" do
      assert @user.cannot?(:create, @sector)
      assert @user.can?(:read, @sector)
      assert @user.cannot?(:update, @sector)
      assert @user.cannot?(:destroy, @sector)
    end

    should "not crud on others companies sectors" do
      other_company_sector = create(:sector, company: create(:company, name: "Other company"))
      assert @user.cannot?(:create, other_company_sector)
      assert @user.cannot?(:read, other_company_sector)
      assert @user.cannot?(:update, other_company_sector)
      assert @user.cannot?(:destroy, other_company_sector)
    end
  end

  context "as an user with admin role I" do
    should "CRUD on my company sectors" do
      @user.add_role! :admin

      assert @user.can?(:create, @sector)
      assert @user.can?(:read, @sector)
      assert @user.can?(:update, @sector)
      assert @user.can?(:destroy, @sector)
    end

    should "not crud on other company sectors" do
      @user.add_role! :admin
      other_company_sector = create(:sector, company: create(:company, name: "Other company"))

      assert @user.cannot?(:create, other_company_sector)
      assert @user.cannot?(:read, other_company_sector)
      assert @user.cannot?(:update, other_company_sector)
      assert @user.cannot?(:destroy, other_company_sector)
    end
  end

  context "as an user with superadmin role I" do
    should "CRUD on any company sector" do
      user = create(:user, email: "superadmin@email.com", company: nil)
      user.add_role! :superadmin

      assert user.can?(:create, sector)
      assert user.can?(:read, sector)
      assert user.can?(:update, sector)
      assert user.can?(:destroy, sector)
    end
  end
end
