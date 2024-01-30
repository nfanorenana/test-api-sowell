class PlacesController < ApplicationController
  before_action :set_place, only: %i[show]

  # GET /places
  def index
    @places = PlaceResource.all(params)

    render jsonapi: @places
  end

  # GET /places/1
  def show
    PlaceResource.new.authorize_from_resource_proxy(:read, @place)
    render jsonapi: @place
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_place
    @place = PlaceResource.find(params)
  end

  def current_ability
    @current_ability ||= PlaceAbility.new(@current_user)
  end
end
