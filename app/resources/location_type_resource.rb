class LocationTypeResource < ApplicationResource
  attribute :name, :string
  attribute :logo_url, :string
  attribute :company_id, :integer, only: [:filterable]
  attribute :nature, :string_enum, allow: LocationType.natures.keys

  belongs_to :company
  has_many :checklists
  has_many :spots
end
