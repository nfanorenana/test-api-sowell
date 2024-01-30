class VisitReportResource < ApplicationResource
  attribute :checkpoints, :array
  attribute :author_id, :integer
  attribute :visit_schedule_id, :integer
  attribute :created_at, :datetime

  belongs_to :visit_schedule
  belongs_to :author, resource: UserResource
  has_many :issue_reports
end
