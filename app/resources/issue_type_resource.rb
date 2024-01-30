class IssueTypeResource < ApplicationResource
  attribute :name, :string
  attribute :logo_url, :string
  attribute :company_id, :integer, only: [:filterable]
  attribute :location_type_id, :integer

  belongs_to :company
  belongs_to :location_type
  has_many :issue_reports
  has_many :checkpoints
end
