class VisitReportsController < ApplicationController
  before_action :set_visit_report, only: %i[show]

  # GET /visit_reports
  def index
    @visit_reports = VisitReportResource.all(params)

    render jsonapi: @visit_reports
  end

  # GET /visit_reports/1
  def show
    VisitReportResource.new.authorize_from_resource_proxy(:read, @visit_report)
    render jsonapi: @visit_report
  end

  # POST /visit_reports
  def create
    @visit_report = VisitReportResource.build(params)

    if @visit_report.save
      render jsonapi: @visit_report, status: :created
    else
      render jsonapi_errors: @visit_report, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visit_report
    @visit_report = VisitReportResource.find(params)
  end

  def current_ability
    @current_ability ||= VisitReportAbility.new(@current_user)
  end
end
