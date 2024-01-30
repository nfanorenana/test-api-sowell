# frozen_string_literal: true

module RoleValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validate :role_is_not_added_twice, if: -> { name.present? }
    validate :role_is_not_added_on_company_members, if: -> { name.present? && name.to_sym == :superadmin }
    validate :role_is_not_added_on_companyless_user, unless: -> { name.present? && name.to_sym == :superadmin }
    validate :role_is_not_added_on_other_company, if: -> { name.present? && sector.present? }
    validate :role_is_not_added_with_a_sector, if: -> { name.present? && %i[superadmin admin].include?(name.to_sym) }
    validate :role_is_not_added_without_sector, unless: lambda {
                                                         name.present? && %i[superadmin admin].include?(name.to_sym)
                                                       }
  end
  def role_is_not_added_twice
    errors.add(:name, I18n.t("validations.role.uniqueness")) if Role.where(user: user,
                                                                           sector: sector).where(name: name.to_sym).present?
  end

  def role_is_not_added_on_company_members
    errors.add(:name, I18n.t("validations.role.superadmin.company_absence")) && return if user.company.present?
  end

  def role_is_not_added_on_companyless_user
    errors.add(:name, I18n.t("validations.role.common.company_presence")) if user.company.blank?
  end

  def role_is_not_added_on_other_company
    errors.add(:name, I18n.t("validations.role.common.sector_company")) unless user.company == sector.company
  end

  def role_is_not_added_with_a_sector
    errors.add(:name, I18n.t("validations.role.common.sector_absence")) && return if sector.present?
  end

  def role_is_not_added_without_sector
    errors.add(:name, I18n.t("validations.role.common.sector_presence")) && return if sector.blank?
  end
end
