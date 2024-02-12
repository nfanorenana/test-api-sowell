# frozen_string_literal: true

module IssueTypeValidatable
  extend ActiveSupport::Concern

  included do
    validates :name, presence: { message: I18n.t("validations.common.name_presence") }
    validate :location_type_should_belong_to_company
    validate :base_location_type_should_be_the_same_for_base_issue_type_and_location_type
  end

  def location_type_should_belong_to_company
    if location_type&.company_id != company_id
      errors.add(:location_type,
                 I18n.t("validations.common.belonging_to_company"))
    end
  end

  def base_location_type_should_be_the_same_for_base_issue_type_and_location_type
    if base_issue_type&.base_location_type != location_type&.base_location_type
      errors.add(:base_issue_type, I18n.t("validations.issue_type.base_location_type_should_be_the_same_for_base_issue_type_and_location_type"))
    end
  end
end
