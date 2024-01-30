class IssueReportAbility
  include CanCan::Ability
  def initialize(user)
    # NOTE: ##################### As an anonymous I

    # should not crud
    return if user.blank?

    # NOTE: ##################### As an authenticated user I

    # should CRUd on my company issue_reports
    can :create, IssueReport, company_id: user.company_id
    can :read, IssueReport, company_id: user.company_id
    can :update, IssueReport, company_id: user.company_id

    return unless user.superadmin?

    # NOTE: ##################### As an user with superadmin role I

    # should CRUD any company issue_report
    can :manage, IssueReport
  end
end
