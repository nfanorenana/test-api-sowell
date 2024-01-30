# frozen_string_literal: true

class Sector < ApplicationRecord
  belongs_to :company
  has_and_belongs_to_many :places,
                          class_name: "Place",
                          join_table: "places_sectors",
                          after_add: :touch_self,
                          after_remove: :touch_self
  has_many :roles, dependent: :destroy
  include SectorValidatable

  scope :by_user_role, lambda { |role_name, users_ids|
    joins(roles: :user).where(user: { id: users_ids.map(&:to_i) }, roles: { name: role_name.to_sym }).distinct
  }

  def agencies
    Agency.joins(residences: :places).where(places: { id: places }).uniq
  end

  def residences
    Residence.joins(:places).where(places: { id: places }).uniq
  end

  private

  def touch_self(_place)
    touch
  end
end
