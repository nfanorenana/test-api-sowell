# frozen_string_literal: true

module Authenticable
  extend ActiveSupport::Concern

  included do
    define_method :authenticate_by_type do |type, password = nil|
      case type
      when "authenticate_with_password"
        # NOTE: it fails with bad password
        return false unless authenticate_password(password)
      when "authenticate_with_one_time_password"
        # NOTE: it fails with bad one time password
        return false unless authenticate_one_time_password(password)
      else
        return false
      end
      return check_and_update
    end

    # Generate and send otp
    define_method :send_one_time_password do
      generate_and_send_otp
    end
  end

  private

  def check_and_update
    # NOTE: it fails with suspended users
    return false if status.to_s == "suspended"

    # NOTE: it fails for companyless users unless it is superadmin
    return false if !superadmin? && company.nil?

    # NOTE: it clears password_recovery_code
    self.one_time_password_digest = nil

    # NOTE: it updates last_connection_at
    self.last_connection_at = DateTime.now

    save!
  end

  def generate_and_send_otp
    self.one_time_password = SecureRandom.hex(3)
    save!
    Postmark::Auth::SendOtpJob.perform_later(email, one_time_password)
  end
end
