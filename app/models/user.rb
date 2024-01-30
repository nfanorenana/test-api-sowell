# frozen_string_literal: true

class User < ApplicationRecord
  extend Enumerize
  include Abilitiable
  include Authenticable
  include Roleable

  has_secure_password
  has_secure_password :one_time_password, validations: false

  belongs_to :company, optional: true

  enum :status, { active: "1", suspended: "2" }

  # NOTE: Forces lower case for email attribute
  def email=(value)
    super(value&.downcase)
  end

  def full_name
    "#{fname} #{lname}"
  end

  include UserValidatable
end
