# frozen_string_literal: true

module Tokenable
  extend ActiveSupport::Concern

  require "json_web_token"

  # FIXME: Reference of controller methods is a bad practice
  included do
    before_action :set_user_from_token!,
                  except: %i[sign_in_password sign_in_one_time_password send_one_time_password]
  end

  protected

  # Validates the token and user and sets the @current_user and @payload
  def set_user_from_token!
    @payload = decode_from_headers
    @current_user = User.find_by(id: @payload["uid"])
  end

  def generate_token(payload)
    JsonWebToken.encode(payload)
  end

  private

  # Deconstructs the Authorization header and decodes the JWT token.
  def decode_from_headers
    token = request.headers["Authorization"]
    JsonWebToken.decode(token)
  rescue StandardError => e
    case e.to_s
    when "expired_token"
      raise Rescueable::Unauthorized.new I18n.t("errors.tokenable.expired"), "Expired token"
    else
      raise Rescueable::Unauthorized.new, I18n.t("errors.tokenable.invalid"), "Invalid token"
    end
  end
end
