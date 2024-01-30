class CheckpointResource < ApplicationResource
  attribute :question, :string
  attribute :description, :string
  attribute :checklist_id, :integer, only: [:filterable]
  attribute :issue_type_id, :integer

  belongs_to :checklist

  filter :visit_schedule_id, :integer do
    eq do |_scope, value|
      VisitSchedule.find(value).checklist.checkpoints
    end
  end
end
