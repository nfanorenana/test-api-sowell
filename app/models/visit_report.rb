class VisitReport < ApplicationRecord
  belongs_to :author, class_name: "User"
  belongs_to :visit_schedule
  has_many :issue_reports, dependent: :destroy

  include VisitReportValidatable
  include VisitReportObserver
end
