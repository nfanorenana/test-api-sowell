class Agency < ApplicationRecord
  include AgencyValidatable
  include AgencyObserver

  belongs_to :company

  has_many :residences, dependent: :destroy
  has_many :visit_schedules, through: :residences

  scope :by_user_role, lambda { |role_name, users_ids|
    joins(residences: { places: { sectors: { roles: :user } } }).where(user: { id: users_ids.map(&:to_i) }, roles: { name: role_name.to_sym }).distinct
  }
end
