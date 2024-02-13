module VisitPropValidatable
  extend ActiveSupport::Concern
  include DepthLevelLocationValidatable

  included do
    validate :check_visit_prop_relation_with_place_residence_or_spot
    validate :check_compatibility_between_location_and_depth_level
  end

  private

  def check_visit_prop_relation_with_place_residence_or_spot
    attributes = [place_id, residence_id, spot_id]
    check_relation_with_place_residence_or_spot(attributes)
  end

  def check_compatibility_between_location_and_depth_level
    depth_level = checklist.location_type.base_location_type.depth_level
    cant_set_incompatible_location_and_depth_level(depth_level, checklist)
  end
end
