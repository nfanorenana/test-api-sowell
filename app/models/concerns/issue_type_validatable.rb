# frozen_string_literal: true

module IssueTypeValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validate :location_type_should_belong_to_company
  end

  def location_type_should_belong_to_company
    if location_type&.company_id != company_id
      errors.add(:location_type,
                 I18n.t("validations.common.belonging_to_company"))
    end
  end
end
