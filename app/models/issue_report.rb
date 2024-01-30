class IssueReport < ApplicationRecord
  include IssueReportValidatable
  include IssueReportObserver

  belongs_to :company
  belongs_to :place
  belongs_to :author, class_name: "User"
  belongs_to :issue_type
  belongs_to :visit_report, optional: true, counter_cache: true
  belongs_to :checkpoint, optional: true
  belongs_to :spot, optional: true

  enum :priority, { low: 0, medium: 1, high: 2 }
  enum :status, { pending: 0, ongoing: 1, done: 2, canceled: 3 }

  scope :by_user_role, lambda { |role_name, users_ids|
    joins("LEFT OUTER JOIN spots sp ON sp.id = issue_reports.spot_id
           LEFT OUTER JOIN places p ON p.id = issue_reports.place_id OR p.id = sp.place_id
           INNER JOIN places_sectors ps ON ps.place_id = p.id
           INNER JOIN sectors s ON s.id = ps.sector_id
           INNER JOIN roles r ON r.sector_id = s.id")
    .where("r.name = '#{Role.names[role_name]}' AND r.user_id IN (#{users_ids.join(",")})")
  }
end
