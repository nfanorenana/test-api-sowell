# frozen_string_literal: true

require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "includes expected concerns" do
    assert User.include?(Abilitiable)
    assert User.include?(Authenticable)
    assert User.include?(Roleable)
  end

  context "#new" do
    should "have expected default values" do
      user = build(:user)
      assert user.email_notifications_activated == true
      assert user.can_close_issues == false
      assert user.status == "active"
      assert user.notifications == []
      assert user.recipients == []
      assert user.hardware == {}
      assert user.superadmin? == false
    end
  end

  context "#email" do
    should "be changeable" do
      user = create(:user)
      user.email = "correct@email.com"
      assert user.save
    end

    should "not be empty" do
      user = build(:user, email: nil)
      assert_not user.valid?
      assert user.errors.first.attribute == :email
      assert user.errors.first.type == :blank
    end

    should "be unique" do
      create(:user)
      user = build(:user)
      assert_not user.save
      assert user.errors.first.attribute == :email
      assert user.errors.first.type == :taken
    end

    should "not be incorrect" do
      user = build(:user, email: "just_text")
      assert_not user.save
      assert user.errors.first.attribute == :email
      assert user.errors.first.type == :invalid
    end

    should "be transformed to lowercase" do
      user = build(:user, email: "UPPER@CASE.EMAIL")
      assert_equal "upper@case.email", user.email
    end
  end

  context "#password" do
    should "be changeable" do
      user = create(:user)
      user.password = "456789"
      assert user.save
    end

    should "not be empty" do
      user = build(:user, password: nil)
      assert_not user.valid?
      assert user.errors.first.attribute == :password
      assert user.errors.first.type == :blank
    end

    should "not be less than 6 characters" do
      user = build(:user)
      user.password = "12345"
      assert_not user.valid?
      assert user.errors.first.attribute == :password
      assert user.errors.first.type == :too_short
    end
  end

  context "#company" do
    should "be settable for new users" do
      user = build(:user, company: nil)
      user.company = create(:company)
      user.save
      assert_empty user.errors
    end

    should "not be settable for superadmins" do
      user = create(:user, company: nil)
      user.add_role! :superadmin
      user.company = create(:company)
      assert_raise(ActiveRecord::RecordInvalid) do
        user.save!
      end
      assert user.errors.first.attribute == :company
      assert user.errors.first.type == :forbidden
    end

    should "not changeable for existing users" do
      company = create(:company)
      user = create(:user, company: company)
      user.company = create(:company, name: "Another company")
      assert_raise(ActiveRecord::RecordInvalid) do
        user.save!
      end
      assert user.errors.first.attribute == :company
      assert user.errors.first.type == :forbidden

      user.company = nil
      assert_raise(ActiveRecord::RecordInvalid) do
        user.save!
      end
      assert user.errors.first.attribute == :company
      assert user.errors.first.type == :forbidden
    end
  end
end
