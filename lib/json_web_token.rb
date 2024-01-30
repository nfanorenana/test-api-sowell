# frozen_string_literal: true

class JsonWebToken
  require "jwt"

  SECRET_KEY = ENV.fetch("JWT_SECRET", nil)

  # Encodes and signs the payload using our app's secret key
  # The result also includes the expiration date
  def self.encode(payload, exp = 7.days.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY, "HS256")
  end

  def self.decode(token)
    payload = get_payload(token)
    raise StandardError, :invalid_token if payload.nil?
    raise StandardError, :expired_token if expired?(payload)

    payload.first
  end

  def self.get_payload(token)
    jwt_string = token.split.last
    JWT.decode(jwt_string, SECRET_KEY, true, algorithm: "HS256")
  rescue StandardError
    nil
  end

  # Validates if the token is expired by exp parameter
  def self.expired?(payload)
    Time.zone.at(payload.first["exp"]) < Time.zone.now
  end
end
