# frozen_string_literal: true

require "test_helper"

class UserAbilityTest < ActionDispatch::IntegrationTest
  setup do
    @company = create(:company)
    @user = create(:user, company: @company)
  end
  context "as an anonymous I" do
    should "not crud" do
      ability = UserAbility.new(nil)

      assert ability.cannot?(:read, User)
      assert ability.cannot?(:update, User)
      assert ability.cannot?(:destroy, User)
      assert ability.cannot?(:create, User)
    end
  end

  context "as an user I" do
    should "cRud on my company users" do
      create(:user, company: @company, email: "another@email.com")

      assert @user.cannot?(:create, User)
      @company.users.each do |u|
        assert @user.can?(:read, u)
        assert @user.cannot?(:update, u) unless u.id == @user.id
      end
      assert @user.cannot?(:destroy, User)
    end

    should "cRUd myself" do
      assert @user.cannot?(:create, User)
      assert @user.can?(:edit, @user)
      assert @user.cannot?(:destroy, User)
    end

    should "not change my company" do
      assert @user.cannot?(:update, User, :company_id)
    end

    should "not crud on other company users" do
      other_company_user = create(:user, email: "another_company@email.com",
                                         company: create(:company, name: "other company"))
      assert @user.cannot?(:create, User)
      assert @user.cannot?(:read, other_company_user)
      assert @user.cannot?(:update, other_company_user)
      assert @user.cannot?(:destroy, User)
    end
  end

  context "as an user with admin role I" do
    should "CRUd my company users" do
      @user.add_role! :admin

      assert @user.can?(:create, User, company: @user.company)
      assert @user.can?(:edit, User, company: @user.company)
      assert @user.cannot?(:destroy, User)
    end

    # FIXME: Add should not crud on other company users
  end

  context "as an user with superadmin role I" do
    should "CRUd any user" do
      user = create(:user, email: "superadmin@email.com", company: nil)
      user.add_role! :superadmin
      assert user.can?(:create, User)
      assert user.can?(:edit, User)
      assert user.cannot?(:destroy, User)
    end
  end
end
