class VisitSchedule < ApplicationRecord
  include VisitScheduleValidatable
  include VisitScheduleObserver

  belongs_to :place
  belongs_to :checklist
  attr_accessor :skip_due_at_validation

  scope :by_user_role, lambda { |role_name, users_ids|
    joins(place: { sectors: { roles: :user } }).where(
      user: { id: users_ids.map(&:to_i) }, roles: { name: role_name.to_sym }
    ).distinct
  }
end
