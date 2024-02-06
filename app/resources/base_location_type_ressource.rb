class BaseLocationTypeResource < ApplicationResource
  attribute :name, :string
  attribute :depth_level, :string_enum, allow: BaseLocationType.depth_levels.keys

  has_many :location_types
end
