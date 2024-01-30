class IssueReportResource < ApplicationResource
  attribute :message, :string
  attribute :priority, :string_enum, allow: IssueReport.priorities.keys
  attribute :author_id, :integer
  attribute :issue_type_id, :integer
  attribute :place_id, :integer
  attribute :spot_id, :integer
  attribute :company_id, :integer
  attribute :visit_report_id, :integer
  attribute :checkpoint_id, :integer
  attribute :created_at, :datetime
  attribute :updated_at, :datetime
  attribute :status, :string_enum, allow: IssueReport.statuses.keys
  attribute :talks, :array
  attribute :imgs, :array

  belongs_to :company
  belongs_to :issue_type
  belongs_to :place
  belongs_to :author, resource: UserResource
  belongs_to :visit_report
  belongs_to :checkpoint
  belongs_to :spot

  before_save do |model|
    model.author_id = current_user.id
    model = issue_report_with_place_set_from_spot(issue_report) if model.place_id.nil? && model.spot_id.present?
    authorize_create_or_update(model) if local_model_is_subject?
  end

  filter :manager_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:manager, value)
    end
  end

  filter :reporter_id, :integer do
    eq do |scope, value|
      scope.by_user_role(:reporter, value)
    end
  end

  private

  def issue_report_with_place_set_from_spot(issue_report)
    spot = Spot.find(issue_report.spot_id)
    issue_report.place = spot.place
    issue_report
  end
end
