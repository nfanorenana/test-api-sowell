# frozen_string_literal: true

module VisitReportValidatable
  extend ActiveSupport::Concern

  included do
    validate :checkpoints_should_all_be_checked
    validate :checkpoints_should_have_correct_statuses
    validate :visit_schedule_should_belong_to_author_company
  end

  private

  def checkpoints_should_all_be_checked
    expected_checkpoints_ids = visit_schedule&.checklist&.checkpoints&.pluck(:id)&.sort
    checked_checkpoints_ids = checkpoints.pluck("id").map(&:to_i).sort

    return if expected_checkpoints_ids == checked_checkpoints_ids

    errors.add(:checkpoints, I18n.t("validations.visit_report.checkpoints_not_complete"))
  end

  def checkpoints_should_have_correct_statuses
    checked_checkpoints_statuses = checkpoints.pluck("status").grep(String).map(&:downcase)

    return if (checked_checkpoints_statuses - %w[ok ko missing]).blank?

    errors.add(:checkpoints, I18n.t("validations.visit_report.invalid_checkpoint_status"))
  end

  def visit_schedule_should_belong_to_author_company
    return if visit_schedule&.place&.company_id == author&.company_id

    errors.add(:visit_schedule, I18n.t("validations.common.belonging_to_company"))
  end
end
