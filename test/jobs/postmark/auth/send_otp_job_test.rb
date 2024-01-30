# frozen_string_literal: true

require "test_helper"
require "webmock/minitest"

module Postmark
  module Auth
    class SendOtpJobTest < ActiveJob::TestCase
      context "#perform" do
        setup do
          @user = create(:user)
          @user.one_time_password = SecureRandom.hex
          @user.save

          stub_request(:post, ENV.fetch("POSTMARK_URL", nil))
            .with(
              body: {
                From: "support@sowellapp.com",
                To: @user.email,
                TemplateId: ENV.fetch("POSTMARK_PASSWORD_RECOVERY_TEMPLATE_V2", nil),
                TemplateModel: {
                  user_reset_otp: @user.one_time_password
                }
              }.to_json
            ).to_return(status: 200)

          Postmark::Auth::SendOtpJob.new.perform(@user.email, @user.one_time_password)
        end

        should "send the expected request to Postmark" do
          assert_requested :post, ENV.fetch("POSTMARK_URL", nil), times: 1, body: {
            From: "support@sowellapp.com",
            To: @user.email,
            TemplateId: ENV.fetch("POSTMARK_PASSWORD_RECOVERY_TEMPLATE_V2", nil),
            TemplateModel: {
              user_reset_otp: @user.one_time_password
            }
          }
        end
      end
    end
  end
end
