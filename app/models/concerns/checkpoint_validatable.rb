# frozen_string_literal: true

module CheckpointValidatable
  extend ActiveSupport::Concern

  included do
    validates :question, presence: { message: I18n.t("validations.checkpoint.question_presence") }
    validate :cannot_set_incompatible_issue_type_and_checklist
  end

  private

  def cannot_set_incompatible_issue_type_and_checklist
    if !issue_type.nil? && !checklist.nil? && (issue_type.company_id != checklist.company_id)
      errors.add(:place, I18n.t("validations.checkpoint.incompatible_issue_type_and_checklist"))
    end
  end
end
