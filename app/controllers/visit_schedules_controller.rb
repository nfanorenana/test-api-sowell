class VisitSchedulesController < ApplicationController
  before_action :set_visit_schedule, only: %i[show]

  # GET /visit_schedules
  def index
    @visit_schedules = VisitScheduleResource.all(params)

    render jsonapi: @visit_schedules
  end

  # GET /visit_schedules/1
  def show
    VisitScheduleResource.new.authorize_from_resource_proxy(:read, @visit_schedule)
    render jsonapi: @visit_schedule
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_visit_schedule
    @visit_schedule = VisitScheduleResource.find(params)
  end

  def current_ability
    @current_ability ||= VisitScheduleAbility.new(@current_user)
  end
end
