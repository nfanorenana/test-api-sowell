class ResidencesController < ApplicationController
  before_action :set_residence, only: %i[show]

  # GET /residences
  def index
    @residences = ResidenceResource.all(params)

    render jsonapi: @residences
  end

  # GET /residences/1
  def show
    ResidenceResource.new.authorize_from_resource_proxy(:read, @residence)
    render jsonapi: @residence
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_residence
    @residence = ResidenceResource.find(params)
  end

  def current_ability
    @current_ability ||= ResidenceAbility.new(@current_user)
  end
end
