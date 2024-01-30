class ChecklistResource < ApplicationResource
  attribute :name, :string
  attribute :logo_url, :string
  attribute :is_planned, :boolean
  attribute :company_id, :integer, only: [:filterable]
  attribute :has_scheduled_visit, :boolean, only: [:filterable]
  attribute :location_type_id, :integer

  belongs_to :company
  belongs_to :location_type
  has_many :checkpoints
end
