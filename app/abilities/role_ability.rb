class RoleAbility
  include CanCan::Ability
  def initialize(current_user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if current_user.blank?

    # NOTE: ##################### As an authenticated current_user I

    # should cRud on my company Roles
    can :read, Role, user: { company_id: current_user.company_id }

    return unless current_user.superadmin? || current_user.admin?

    # NOTE: ##################### As a current_user with admin role I

    # Should CRUD on my company Roles

    can :create, Role, user: { company_id: current_user.company_id }
    if current_user.admin?
      cannot :create, Role, name: :superadmin
      cannot :create, Role, name: :admin
    end
    can :update, Role, user: { company_id: current_user.company_id }
    can :destroy, Role, user: { company_id: current_user.company_id }

    return unless current_user.superadmin?

    # NOTE: ##################### As a user with superadmin role I

    # should CRUD any company Role
    can :manage, Role
  end
end
