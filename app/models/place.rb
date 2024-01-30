class Place < ApplicationRecord
  include PlaceValidatable
  include PlaceObserver

  belongs_to :company
  belongs_to :residence

  has_many :visit_schedules, dependent: :destroy
  has_many :spots, dependent: :destroy
  has_and_belongs_to_many :sectors, class_name: "Sector", join_table: "places_sectors"

  scope :by_user_role, lambda { |role_name, users_ids|
    joins(sectors: { roles: :user }).where(user: { id: users_ids.map(&:to_i) }, roles: { name: role_name.to_sym }).distinct
  }
end
