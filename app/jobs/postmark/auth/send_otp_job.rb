# frozen_string_literal: true

module Postmark
  module Auth
    class SendOtpJob < ApplicationJob
      require "net/http"
      require "json"
      require "open-uri"

      def perform(email, reset_otp)
        ActiveRecord::Base.connection_pool.with_connection do
          # NOTE: Pushes to postmark
          Net::HTTP.post URI(ENV.fetch("POSTMARK_URL", nil)),
                         payload(email, reset_otp).to_json,
                         "Content-Type" => "application/json",
                         "Accept" => "application/json",
                         "X-Postmark-Server-Token" => ENV.fetch("POSTMARK_API_KEY", nil)
        end
      end

      private

      def payload(email, reset_otp)
        {
          From: "support@sowellapp.com",
          To: email,
          TemplateId: ENV.fetch("POSTMARK_PASSWORD_RECOVERY_TEMPLATE_V2", nil),
          TemplateModel: {
            user_reset_otp: reset_otp
          }
        }
      end
    end
  end
end
