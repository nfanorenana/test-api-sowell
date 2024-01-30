# frozen_string_literal: true

require "test_helper"

class AuthenticableTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  context "#authenticate_with_password" do
    setup do
      @user = create(:user, password: "123456", one_time_password: "654321")
      @user.add_role!(:superadmin)
    end
    should "succeed with the right password" do
      assert @user.authenticate_by_type("authenticate_with_password", "123456")
    end

    should "fail with a bad password" do
      assert_not @user.authenticate_by_type("authenticate_with_password", "badpassword")
      assert_not @user.authenticate_by_type("authenticate_with_password", "")
      assert_not @user.authenticate_by_type("authenticate_with_password", nil)
    end

    should "fail for suspended users" do
      @user.update(status: :suspended)
      assert_not @user.authenticate_by_type("authenticate_with_password", "123456")
    end

    should "fail for companyless users if not superadmin" do
      @user.remove_role!(:superadmin)
      assert_not @user.authenticate_by_type("authenticate_with_password", "123456")
    end

    should "clear one_time_password on success" do
      @user.authenticate_by_type("authenticate_with_password", "123456")
      assert_nil User.find(@user.id).one_time_password
    end

    should "update last_connection_at on success" do
      @user.update(last_connection_at: DateTime.now - 1.year)
      freeze_time do
        @user.authenticate_by_type("authenticate_with_password", "123456")
        assert_equal DateTime.now, User.find(@user.id).last_connection_at
      end
    end
  end

  context "#authenticate_with_one_time_password" do
    setup do
      @user = create(:user, password: "123456", one_time_password: "654321")
      @user.add_role!(:superadmin)
    end
    should "succeed with the right password" do
      assert @user.authenticate_by_type("authenticate_with_one_time_password", "654321")
    end

    should "fail with a bad password" do
      assert_not @user.authenticate_by_type("authenticate_with_one_time_password", "badpassword")
      assert_not @user.authenticate_by_type("authenticate_with_one_time_password", "")
      assert_not @user.authenticate_by_type("authenticate_with_one_time_password", nil)
    end

    should "fail for suspended users" do
      @user.update(status: :suspended)
      assert_not @user.authenticate_by_type("authenticate_with_one_time_password", "654321")
    end

    should "fail for companyless users if not superadmin" do
      @user.remove_role!(:superadmin)
      assert_not @user.authenticate_by_type("authenticate_with_one_time_password", "654321")
    end

    should "clear one_time_password on success" do
      @user.authenticate_by_type("authenticate_with_one_time_password", "654321")
      assert_nil User.find(@user.id).one_time_password
    end

    should "update last_connection_at on success" do
      @user.update(last_connection_at: DateTime.now - 1.year)
      freeze_time do
        @user.authenticate_by_type("authenticate_with_one_time_password", "654321")
        assert_equal DateTime.now, User.find(@user.id).last_connection_at
      end
    end
  end

  context "#send_one_time_password" do
    setup do
      @user = create(:user, password: "123456")
      @user.add_role!(:superadmin)
    end
    should "call the right Postmark job" do
      @user.update(one_time_password_digest: nil)
      assert_enqueued_with(job: Postmark::Auth::SendOtpJob) do
        @user.send_one_time_password
      end
    end

    should "set a new one time password" do
      @user.update(one_time_password_digest: nil)
      @user.send_one_time_password
      assert_not_empty User.find(@user.id).one_time_password_digest
    end
  end
end
