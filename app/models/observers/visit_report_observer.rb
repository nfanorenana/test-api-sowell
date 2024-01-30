module VisitReportObserver
  extend ActiveSupport::Concern

  included do
    after_create :setup_next_visit_schedule_date, if: -> { visit_schedule.checklist.is_planned }
  end

  def setup_next_visit_schedule_date
    next_due_date = created_at + visit_schedule.checklist.recurrence
    visit_schedule.due_at = next_due_date
    visit_schedule.save
  end
end
