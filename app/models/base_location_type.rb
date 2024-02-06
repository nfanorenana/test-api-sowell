class BaseLocationType < ApplicationRecord
  include BaseLocationTypeValidatable

  has_many :base_issue_types
  has_many :location_types, dependent: :destroy

  enum :depth_level, { residence: 1, place: 2, spot: 3 }
end
