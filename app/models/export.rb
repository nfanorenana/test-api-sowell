class Export < ApplicationRecord
  include ExportValidatable

  belongs_to :author, class_name: "User"

  enum :status, { pending: 0, ongoing: 1, done: 2 }

end
