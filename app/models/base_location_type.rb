class BaseLocationType < ApplicationRecord
  include BaseLocationTypeValidatable

  has_many :location_type, dependent: :destroy

  enum :depth_level, { residence: 1, place: 2, spot: 3 }
end
