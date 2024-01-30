class VisitReportAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # should cRud on my company visit_reports
    # NOTE: Access to this resource's "company_id:" may need some editing
    can :read, VisitReport, author: { company_id: user.company_id }
    can :create, VisitReport, visit_schedule: { place: { company_id: user.company_id } }

    return unless user.superadmin?

    can :manage, VisitReport
  end
end
