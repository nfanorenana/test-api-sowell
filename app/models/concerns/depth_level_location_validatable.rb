module DepthLevelLocationValidatable
  extend ActiveSupport::Concern

  private

  def check_relation_with_place_residence_or_spot(attributes)
    unless attributes.is_a?(Array)
      errors.add(:base, I18n.t('validations.visit_schedule_or_prop.require_array'))
    end

    if attributes.compact.size != 1
      errors.add(:base, I18n.t('validations.visit_schedute_or_prop.incompatible_location_number_for_visit_schedule'))
    end
  end

  def cant_set_incompatible_location_and_depth_level(depth_level, check)
    case depth_level
    when 'place', 'residence', 'spot'
      if send("#{depth_level}_id").nil?
        errors.add(:base, I18n.t('validations.visit_schedule_or_prop.incompatible_location_and_depth_level'))
      end
      check_if_checklist_or_checkpoint(depth_level, check)
    end
  end

  def check_if_checklist_or_checkpoint(location, check)
    check.instance_of?(Checkpoint) ? check_compatibility_between_location_and_checkpoint(location) : check_compatibility_between_location_and_checklist(location)
  end

  def check_compatibility_between_location_and_checklist(location)
    case location
    when 'place', 'residence'
      if !send("#{location}").nil? && !checklist.nil? && (send("#{location}").company_id != checklist.company_id)
        errors.add(:base, I18n.t("validations.visit_schedule.incompatible_#{location}_and_checklist"))
      end
    else
      if !send("#{location}").nil? && !checklist.nil? && (send("#{location}").company_id != checklist.company_id)
        errors.add(:base, I18n.t("validations.visit_schedule.incompatible_#{location}_and_checklist"))
      end
    end
  end

  def check_compatibility_between_location_and_checkpoint(location)
    case location
    when 'place', 'residence'
      if !send("#{location}").nil? && !checkpoint.nil? && (send("#{location}").company_id != checkpoint.checklist.company_id)
        errors.add(:base, I18n.t("validations.visit_prop.incompatible_#{location}_and_checkpoint"))
      end
    else
      if !send("#{location}").nil? && !checkpoint.nil? && (send("#{location}").place.company_id != checkpoint.checklist.company_id)
        errors.add(:base, I18n.t("validations.visit_prop.incompatible_#{location}_and_checkpoint"))
      end
    end
  end
end
