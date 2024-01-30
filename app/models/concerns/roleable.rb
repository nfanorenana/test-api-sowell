# frozen_string_literal: true

module Roleable
  extend ActiveSupport::Concern

  included do
    has_many :roles, dependent: :destroy
    has_many :sectors, through: :roles

    accepts_nested_attributes_for :roles
  end

  # NOTE: Is given role present
  def superadmin?
    roles.where(name: "superadmin").present?
  end

  def admin?
    roles.where(name: "admin").present?
  end

  def manager?
    roles.where(name: "manager").present?
  end

  def reporter?
    roles.where(name: "reporter").present?
  end

  def checklister?
    roles.where(name: "checklister").present?
  end

  # NOTE: Update roles
  def add_role!(role_name, sector = nil)
    Role.create!(name: role_name, user: self, sector: sector)
  end

  def remove_role!(role_name, sector = nil)
    Role.find_by(name: role_name, user: self, sector: sector).destroy!
  end

  def manageable_sectors
    sectors_by_role("manager")
  end

  def reportable_sectors
    sectors_by_role("reporter")
  end

  def checklistable_sectors
    sectors_by_role("checklister")
  end

  private

  def sectors_by_role(role_name)
    roles.where(name: role_name).includes(:sector).map(&:sector)
  end
end
