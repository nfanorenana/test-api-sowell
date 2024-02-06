class BaseIssueType < ApplicationRecord
  include BaseIssueTypeValidatable

  belongs_to :base_location_type

  has_many :issue_types, dependent: :destroy

end
