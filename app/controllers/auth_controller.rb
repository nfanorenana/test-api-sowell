# frozen_string_literal: true

class AuthController < ApplicationController
  # POST /sign_in
  def sign_in_password
    sign_in("authenticate_with_password")
  end

  def sign_in_one_time_password
    sign_in("authenticate_with_one_time_password")
  end

  def send_one_time_password
    email = params.require(:auth).permit(:email)[:email]
    user = User.find_by(email: email)

    unless user.present? && user.send_one_time_password
      raise Rescueable::UnprocessableEntity,
            I18n.t("errors.otp.unprocessable")
    end

    render status: :created
  end

  private

  def sign_in(type)
    credentials = params.require(:auth).permit :email, :password
    user = User.find_by(email: credentials[:email])
    requested_roles = request.headers["x-requested-roles"]&.split(",")&.compact&.collect(&:strip)

    # finds existing user, checks to see if user can be authenticated
    unless user.present? && user.authenticate_by_type(type, credentials[:password])
      raise Rescueable::Unauthorized.new I18n.t("errors.sign_in.unauthorized"),
                                         "Invalid credentials"
    end

    referer = request.referer
    unless user_has_requested_roles?(user, requested_roles)
      raise Rescueable::Forbidden.new I18n.t("errors.sign_in.forbidden"),
                                      "Insufficient roles"
    end

    # sets up token
    token = generate_token({ uid: user.id, cid: user.company_id, aud: referer })

    render json: { auth: token }, status: :created
  end

  def user_has_requested_roles?(user, requested_roles = [])
    return true if requested_roles.blank?

    all_owned_roles = user.roles.pluck(:name).uniq
    requested_roles.any? { |role| all_owned_roles.include?(role) }
  end
end
