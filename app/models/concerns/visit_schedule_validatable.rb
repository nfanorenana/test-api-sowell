module VisitScheduleValidatable
  extend ActiveSupport::Concern

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
    if attributes.compact.size != 1
      errors.add(:base, I18n.t("validations.visit_schedute.incompatible_location_number_for_visit_schedule"))
    end
  end

  def cant_set_incompatible_location_and_depth_level
    depth_level = checklist.location_type.base_location_type.depth_level
    case depth_level
    when 'place', 'residence', 'spot'
      if send("#{depth_level}").nil?
        errors.add(:base, I18n.t("validations.visit_schedule.incompatible_visit_schedule_location_and_depth_level"))
      end
      check_compatibility_between_location_and_checklist(depth_level)
    else
      errors.add(:base, I18n.t("validations.visit_schedule.unknown_depth_level"))
    end
  end

  def check_compatibility_between_location_and_checklist(location)
    case location
    when 'place', 'residence'
      if !send("#{location}").nil? && !checklist.nil? && (send("#{location}").company_id != checklist.company_id)
        errors.add(location_type, I18n.t("validations.visit_schedule.incompatible_place_and_checklist"))
      end
    else
      if !send("#{location}").nil? && !checklist.nil? && (!send("#{location}").place.company_id != checklist.company_id)
        errors.add(location_type, I18n.t("validations.visit_schedule.incompatible_spot_and_checklist"))
      end
    end
  end

end
