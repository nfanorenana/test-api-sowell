module VisitPropValidatable
  extend ActiveSupport::Concern
  include DepthLevelLocationValidatable

  included do
    validate :check_visit_prop_relation_with_place_residence_or_spot
    validate :cant_set_incompatible_location_and_depth_level
    # validate :check_compatibility_between_location_and_depth_level
  end

  private

  def check_visit_prop_relation_with_place_residence_or_spot
    attributes = [place, residence, spot]
    check_relation_with_place_residence_or_spot(attributes)
  end

  def base_location_type
    return checkpoint.checklist.location_type.base_location_type
  end

  def company_id
    return checkpoint.checklist.company_id
  end

  def checklist
    return checkpoint.checklist
  end

  def check_compatibility_between_location_and_depth_level
    depth_level = checkpoint.checklist.location_type.base_location_type.depth_level
    cant_set_incompatible_location_and_depth_level(checklist)
  end
end
