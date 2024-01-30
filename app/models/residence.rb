class Residence < ApplicationRecord
  include ResidenceValidatable
  include ResidenceObserver

  belongs_to :company
  belongs_to :agency

  has_many :places, dependent: :destroy
  has_many :visit_schedules, through: :places

  scope :by_user_role, lambda { |role_name, users_ids|
    joins(places: { sectors: { roles: :user } }).where(user: { id: users_ids.map(&:to_i) }, roles: { name: role_name.to_sym }).distinct
  }
end
