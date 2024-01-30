class IssueTypesController < ApplicationController
  before_action :set_issue_type, only: %i[show update destroy]

  # GET /issue_types
  def index
    @issue_types = IssueTypeResource.all(params)

    render jsonapi: @issue_types
  end

  # GET /issue_types/1
  def show
    IssueTypeResource.new.authorize_from_resource_proxy(:read, @issue_type)
    render jsonapi: @issue_type
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_issue_type
    @issue_type = IssueTypeResource.find(params)
  end

  def current_ability
    @current_ability ||= IssueTypeAbility.new(@current_user)
  end
end
