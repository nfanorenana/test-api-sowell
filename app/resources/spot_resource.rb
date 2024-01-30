class SpotResource < ApplicationResource
  attribute :name, :string
  attribute :place_id, :integer
  attribute :location_type_id, :integer

  belongs_to :place
  belongs_to :location_type
end
