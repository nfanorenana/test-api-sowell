# frozen_string_literal: true

class UserAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # Should cRud on my company users
    can :read, User, company_id: user.company_id

    # Should cRUd myself
    can :update, User, %i[first_name last_name password], id: user.id

    return unless user.superadmin? || user.admin?

    # NOTE: ##################### As an user with admin role I

    # Should CRUd on my company users
    can :create, User, company_id: user.company_id
    can :update, User, company_id: user.company_id

    return unless user.superadmin?

    # NOTE: ##################### As an user with superadmin role I

    # Should CRUd on any company user
    can %i[create read update], User
  end
end
