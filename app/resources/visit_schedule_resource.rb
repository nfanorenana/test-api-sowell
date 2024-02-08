class VisitScheduleResource < ApplicationResource
  attribute :due_at, :datetime
  attribute :checklist_id, :integer
  attribute :place_id, :integer
  attribute :residence_id, :integer
  attribute :spot_id, :integer

  belongs_to :checklist
  belongs_to :place
  belongs_to :residence
  belongs_to :spot

  filter :due_until, :string do
    eq do |visit_schedules, value|
      visit_schedules.where("due_at <= ?", value)
    end
  end

  filter :checklister_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:checklister, value)
    end
  end
end
