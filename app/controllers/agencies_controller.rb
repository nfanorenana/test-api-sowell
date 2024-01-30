class AgenciesController < ApplicationController
  before_action :set_agency, only: %i[show]

  # GET /agencies
  def index
    @agencies = AgencyResource.all(params)

    render jsonapi: @agencies
  end

  # GET /agencies/1
  def show
    AgencyResource.new.authorize_from_resource_proxy(:read, @agency)
    render jsonapi: @agency
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_agency
    @agency = AgencyResource.find(params)
  end

  def current_ability
    @current_ability ||= AgencyAbility.new(@current_user)
  end
end
