# frozen_string_literal: true

require "test_helper"

class RoleTest < ActiveSupport::TestCase
  context "#name" do
    should "not be empty" do
      company = create(:company)
      user = create(:user, company: company)
      sector = create(:sector, company: company)
      role = Role.new(user: user, sector: sector, name: nil)
      assert_raise(ActiveRecord::RecordInvalid) do
        role.save!
      end
      assert role.errors.first.attribute == :name
      assert role.errors.first.type == :blank
    end

    should "be included in roles list" do
      company = create(:company)
      user = create(:user, company: company)
      sector = create(:sector, company: company)
      role = Role.new(user: user, sector: sector, name: :unknown)
      assert_raise(ActiveRecord::RecordInvalid) do
        role.save!
      end
      assert role.errors.first.attribute == :name
      assert role.errors.first.type == :inclusion

      role.name = 999
      assert_raise(ActiveRecord::RecordInvalid) do
        role.save!
      end
      assert role.errors.first.attribute == :name
      assert role.errors.first.type == :inclusion
    end
  end

  context "superadmin role" do
    should "not be added on users belonging to a company" do
      company = create(:company)
      user = create(:user, company: company)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:superadmin)
      end
    end

    should "not be added twice on same user" do
      user = create(:user)
      user.add_role!(:superadmin)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:superadmin)
      end
    end

    should "not be added with a sector" do
      user = create(:user)
      company = create(:company)
      sector = create(:sector, company: company, name: "not_permitted")
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:superadmin, sector)
      end
    end
  end

  context "admin role" do
    should "not be added on users not belonging to a company" do
      user = create(:user)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:admin)
      end
    end

    should "not be added twice on same user" do
      company = create(:company)
      user = create(:user, company: company)
      user.add_role!(:admin)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:admin)
      end
    end

    should "not be added with a sector" do
      company = create(:company)
      user = create(:user, company: company)
      sector = create(:sector, company: company, name: "not_permitted")
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:admin, sector)
      end
    end
  end

  context "manager, reporter and checkliter roles" do
    should "not be added twice to same user on same sector" do
      company = create(:company)
      user = create(:user, company: company)
      sector = create(:sector, company: company, name: "man_sector_one")
      user.add_role!(:manager, sector)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:manager, sector)
      end

      user.add_role!(:reporter, sector)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:reporter, sector)
      end

      user.add_role!(:checklister, sector)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:checklister, sector)
      end
    end

    should "not be added without sector" do
      company = create(:company)
      user = create(:user, company: company)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:manager)
      end
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:reporter)
      end
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:checklister)
      end
    end

    should "not be added to users not belonging to a company" do
      company = create(:company)
      user = create(:user)
      sector = create(:sector, company: company, name: "man_sector_one")

      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:manager, sector)
      end

      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:reporter, sector)
      end

      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:checklister, sector)
      end
    end

    should "not be added on sector belonging to another company" do
      company = create(:company)
      user = create(:user, email: "an@user.com", company: company)
      sector = create(:sector, company: create(:company, name: "another_company"), name: "man_sector_one")
      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:manager, sector)
      end

      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:reporter, sector)
      end

      assert_raise(ActiveRecord::RecordInvalid) do
        user.add_role!(:checklister, sector)
      end
    end
  end
end
