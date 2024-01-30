class ChecklistsController < ApplicationController
  before_action :set_checklist, only: %i[show]

  # GET /checklists
  def index
    @checklists = ChecklistResource.all(params)

    render jsonapi: @checklists
  end

  # GET /checklists/1
  def show
    ChecklistResource.new.authorize_from_resource_proxy(:read, @checklist)
    render jsonapi: @checklist
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_checklist
    @checklist = ChecklistResource.find(params)
  end

  def current_ability
    @current_ability ||= ChecklistAbility.new(@current_user)
  end
end
