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

  def cant_set_incompatible_location_and_depth_level
    depth_level = self.base_location_type.depth_level
    case depth_level
    when 'place', 'residence', 'spot'
      if send("#{depth_level}_id").nil?
        errors.add(:base, I18n.t('validations.visit_schedule_or_prop.incompatible_location_and_depth_level'))
      end
      if !send("#{depth_level}").nil? && !checklist.nil? && (send("#{depth_level}").company_id != self.company_id)
        errors.add(:base, I18n.t("validations.visit_schedule.incompatible_#{location}_and_checklist"))
      end
    end
  end
end
