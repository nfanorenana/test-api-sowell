# frozen_string_literal: true

class CompanyAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # should cRud on my company
    can :read, Company, id: user.company_id

    return unless user.superadmin? || user.admin?

    # NOTE: ##################### As an user with admin role I

    # Should cRUd on my company
    can :update, Company, id: user.company_id

    return unless user.superadmin?

    # NOTE: ##################### As an user with superadmin role I

    # Should CRUD on any company
    can :manage, Company
  end
end
