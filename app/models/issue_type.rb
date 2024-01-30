class IssueType < ApplicationRecord
  belongs_to :company
  belongs_to :location_type

  include IssueTypeValidatable
end
