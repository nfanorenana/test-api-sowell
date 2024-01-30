# frozen_string_literal: true

class SectorAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # should cRud on my company Sectors
    can :read, Sector, company_id: user.company_id

    return unless user.superadmin? || user.admin?

    # NOTE: ##################### As an user with admin role I

    # Should CRUD on my company Sectors
    can :create, Sector, company_id: user.company_id
    can :update, Sector, company_id: user.company_id
    can :destroy, Sector, company_id: user.company_id

    return unless user.superadmin?

    # NOTE: ##################### As an user with superadmin role I

    # should CRUD any company Sector
    can :manage, Sector
  end
end
