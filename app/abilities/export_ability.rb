class ExportAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?
    
    # NOTE: ##################### As an authenticated user I

    # should cRud on my company exports
    # NOTE: Access to this resource's "company_id:" may need some editing
    can :read, Export, company_id: user.company_id
  end
end
