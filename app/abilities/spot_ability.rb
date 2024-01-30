class SpotAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I
    can :read, Spot, place: { company_id: user.company_id }

    # should cRud on my company spots
    # NOTE: Access to this resource's "company_id:" may need some editing
    can :read, Spot if user.superadmin?
  end
end
