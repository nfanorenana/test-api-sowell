# frozen_string_literal: true

module IssueReportValidatable
  extend ActiveSupport::Concern

  included do
    validates :message, presence: true
    validate :related_models_should_belong_to_author_company
    validate :housing_issue_report_should_have_a_spot
    validate :spot_should_be_related_to_place
    validate :talks_contains_only_non_blank_text
    # TODO: Validate that "imgs" does not exceed 3
  end

  private

  def related_models_should_belong_to_author_company
    return if author&.superadmin?

    # Add validation for each relation below
    relations = [issue_type, place]
    relations << spot unless spot.nil?
    relations.each do |relation|
      unless belongs_to_company(relation)
        errors.add(relation.class.name.to_sym,
                   I18n.t("validations.common.belonging_to_company"))
      end
    end
  end

  def housing_issue_report_should_have_a_spot
    return unless issue_type&.location_type&.nature == "housing" && spot.nil?

    errors.add(:spot,
               I18n.t("validations.issue_report.housing_type_has_spot"))
  end

  def spot_should_be_related_to_place
    return if spot.nil? || spot.place == place

    errors.add(:spot,
               I18n.t("validations.issue_report.spot_and_place_are_related"))
  end

  def belongs_to_company(relation)
    if relation.instance_of?(::Spot)
      relation&.place&.company_id == author&.company_id
    else
      relation&.company_id == author&.company_id
    end
  end

  def talks_contains_only_non_blank_text
    return if talks.nil?

    talks.each do |talk|
      next unless talk.key?("message")

      if talk["message"].instance_of?(String)
        errors.add(:talks, I18n.t("validations.issue_report.talks_is_empty_text")) if talk["message"].blank?
      else
        errors.add(:talks, I18n.t("validations.issue_report.talks_contains_only_text"))
      end
    end
  end
end
