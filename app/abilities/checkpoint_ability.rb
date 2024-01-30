class CheckpointAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # should cRud on my company checkpoints
    # NOTE: Access to this resource's "company_id:" may need some editing
    can :read, Checkpoint, checklist: { company_id: user.company_id }

    # NOTE: ##################### As an user with superadmin role I
    can :read, Checkpoint if user.superadmin?
  end
end
