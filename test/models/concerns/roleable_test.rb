# frozen_string_literal: true

require "test_helper"

class RoleableTest < ActiveSupport::TestCase
  context "has_role like helpers" do
    setup do
      @company = create(:company)
      @user = create(:user, company: @company)
      @sector = create(:sector, company: @company)
    end
    should "respond to superadmin?" do
      user = create(:user, company: nil, email: "another@email.com")
      Role.create!(name: :superadmin, user: user)
      assert user.superadmin?
      assert_equal 1, user.roles.count

      Role.find_by(name: :superadmin, user: user).destroy!
      assert_not user.superadmin?
      assert_equal 0, user.roles.count
    end

    should "respond to admin?" do
      Role.create!(name: :admin, user: @user)
      assert @user.admin?
      assert_equal 1, @user.roles.count

      Role.find_by(name: :admin, user: @user).destroy!
      assert_not @user.admin?
      assert_equal 0, @user.roles.count
    end

    should "respond to manager?" do
      Role.create!(name: :manager, user: @user, sector: @sector)
      assert @user.manager?
      assert_equal 1, @user.roles.count

      Role.find_by(name: :manager, user: @user, sector: @sector).destroy!
      assert_not @user.manager?
      assert_equal 0, @user.roles.count
    end

    should "respond to reporter?" do
      Role.create!(name: :reporter, user: @user, sector: @sector)
      assert @user.reporter?
      assert_equal 1, @user.roles.count

      Role.find_by(name: :reporter, user: @user, sector: @sector).destroy!
      assert_not @user.reporter?
      assert_equal 0, @user.roles.count
    end

    should "respond to checklister?" do
      Role.create!(name: :checklister, user: @user, sector: @sector)
      assert @user.checklister?
      assert_equal 1, @user.roles.count

      Role.find_by(name: :checklister, user: @user, sector: @sector).destroy!
      assert_not @user.checklister?
      assert_equal 0, @user.roles.count
    end
  end

  context "list sectors helpers" do
    setup do
      @company = create(:company)
      @user = create(:user, company: @company)
    end
    should "return expected sectors list for the given role name" do
      Role.create!(name: :manager, user: @user, sector: create(:sector, company: @company, name: "man_sector_one"))
      Role.create!(name: :reporter, user: @user, sector: create(:sector, company: @company, name: "rep_sector_one"))
      Role.create!(name: :reporter, user: @user, sector: create(:sector, company: @company, name: "rep_sector_two"))
      Role.create!(name: :checklister, user: @user, sector: create(:sector, company: @company, name: "che_sector_one"))
      Role.create!(name: :checklister, user: @user, sector: create(:sector, company: @company, name: "che_sector_two"))
      Role.create!(name: :checklister, user: @user, sector: create(:sector, company: @company, name: "che_sector_thr"))

      assert_equal 1, @user.manageable_sectors.count
      assert_equal 2, @user.reportable_sectors.count
      assert_equal 3, @user.checklistable_sectors.count
    end
  end

  context "roles management helpers" do
    setup do
      @company = create(:company)
      @user = create(:user, company: @company)
      @sector = create(:sector, company: @company)
    end
    should "add unsectord role" do
      @user.add_role!(:admin)
      assert @user.roles.where(name: "admin").present?
      assert_equal 1, @user.roles.count
    end

    should "remove unsectord role" do
      Role.create!(name: :admin, user: @user)
      @user.remove_role!(:admin)
      assert_equal 0, @user.roles.count
    end

    should "add sectord role" do
      @user.add_role!(:manager, @sector)
      assert @user.roles.where(name: "manager").present?
      assert_equal 1, @user.roles.count

      other_sector = create(:sector, name: "Other sector", company: @company)
      @user.add_role!(:manager, other_sector)
      assert @user.roles.where(name: "manager").present?
      assert_equal 2, @user.roles.count
    end

    should "remove sectord role" do
      Role.create!(name: :manager, user: @user, sector: @sector)
      other_sector = create(:sector, name: "Other sector", company: @company)
      Role.create!(name: :manager, user: @user, sector: other_sector)
      assert_equal 2, @user.roles.count

      @user.remove_role!(:manager, other_sector)
      assert_equal 1, @user.roles.count
      assert_equal @sector, @user.roles.first.sector
    end
  end
end
