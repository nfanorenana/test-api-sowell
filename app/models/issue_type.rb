class IssueType < ApplicationRecord
  belongs_to :base_issue_type
  belongs_to :company
  belongs_to :location_type

  include IssueTypeValidatable
end
