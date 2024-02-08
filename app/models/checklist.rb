class Checklist < ApplicationRecord
  belongs_to :company
  belongs_to :location_type

  has_many :visit_schedule, dependent: :destroy
  has_many :checkpoints, dependent: :destroy

  include ChecklistValidatable
end
