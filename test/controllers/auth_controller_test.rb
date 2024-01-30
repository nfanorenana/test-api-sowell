# frozen_string_literal: true

require "test_helper"
class AuthControllerTest < ActionDispatch::IntegrationTest
  context "as an user with superadmin role I" do
    setup do
      @user = create(:user, password: "123456", one_time_password: "123otp")
      @user.add_role!(:superadmin)
    end
    should "sign in with password" do
      post sign_in_url,
           params: { auth: { email: @user.email, password: "123456" } }
      assert_equal "201", response.code
    end

    should "sign in with one time password" do
      post sign_in_otp_url,
           params: { auth: { email: @user.email, password: "123otp" } }
      assert_equal "201", response.code
    end

    should "request a one time password" do
      post send_otp_url,
           params: { auth: { email: @user.email } }
      assert_equal "201", response.code
    end
  end
end
