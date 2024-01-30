class SpotsController < ApplicationController
  before_action :set_spot, only: %i[show]

  # GET /spots
  def index
    @spots = SpotResource.all(params)

    render jsonapi: @spots
  end

  # GET /spots/1
  def show
    SpotResource.new.authorize_from_resource_proxy(:read, @spot)
    render jsonapi: @spot
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_spot
    @spot = SpotResource.find(params)
  end

  def current_ability
    @current_ability ||= SpotAbility.new(@current_user)
  end
end
