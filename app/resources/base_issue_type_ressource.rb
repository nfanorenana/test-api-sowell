class BaseIssueTypeResource < ApplicationResource
  attribute :name, :string
  attribute :base_location_type_id, :integer, only: [:filterable]

  belongs_to :base_location_type

  has_many :issue_types
end
