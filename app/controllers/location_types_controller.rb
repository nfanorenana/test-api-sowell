class LocationTypesController < ApplicationController
  before_action :set_location_type, only: %i[show]

  # GET /location_types
  def index
    @location_types = LocationTypeResource.all(params)

    render jsonapi: @location_types
  end

  # GET /location_types/1
  def show
    LocationTypeResource.new.authorize_from_resource_proxy(:read, @location_type)
    render jsonapi: @location_type
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_location_type
    @location_type = LocationTypeResource.find(params)
  end

  def current_ability
    @current_ability ||= LocationTypeAbility.new(@current_user)
  end
end
