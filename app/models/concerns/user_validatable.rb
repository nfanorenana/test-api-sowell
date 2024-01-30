# frozen_string_literal: true

module UserValidatable
  extend ActiveSupport::Concern

  included do
    validates :email, presence: { message: I18n.t("validations.common.email_presence") }
    validates :email, uniqueness: { case_sensitive: false }
    validates :email, format: { with: /.+@.+\..+/i }
    validates :password, presence: true, length: { minimum: 6 }, if: :password
    validate :company_should_not_be_set_for_superadmins, on: :update, if: -> { company_id_changed? }
    validate :company_should_not_change_for_existing_users, on: :update, if: -> { company_id_changed? }
  end

  private

  def company_should_not_be_set_for_superadmins
    errors.add(:company, :forbidden) if superadmin?
  end

  def company_should_not_change_for_existing_users
    errors.add(:company, :forbidden)
  end
end
