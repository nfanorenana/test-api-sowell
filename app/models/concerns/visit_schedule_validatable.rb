module VisitScheduleValidatable
  extend ActiveSupport::Concern
  include DepthLevelLocationValidatable

  included do
    validates :due_at, presence: true, if: -> { checklist&.is_planned }
    validates :due_at, absence: true, unless: -> { checklist&.is_planned }
    validate :cant_set_invalid_due_at, on: :update, unless: -> { skip_due_at_validation || !checklist&.is_planned }
    validate :check_visit_schedule_relation_with_place_residence_or_spot
    validate :cant_set_incompatible_location_and_depth_level
  end

  private

  def cant_set_invalid_due_at
    errors.add(:due_at, I18n.t("validations.visit_schedule.invalide_due_at")) if due_at.nil? || due_at < DateTime.now
  end

  def check_visit_schedule_relation_with_place_residence_or_spot
    attributes = [place, residence, spot]
    check_relation_with_place_residence_or_spot(attributes)
  end

  def base_location_type
    return checklist.location_type.base_location_type
  end

  def company_id
    return checklist.company_id
  end

end
