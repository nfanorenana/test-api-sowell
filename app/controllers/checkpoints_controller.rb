class CheckpointsController < ApplicationController
  before_action :set_checkpoint, only: %i[show update destroy]

  # GET /checkpoints
  def index
    @checkpoints = CheckpointResource.all(params)

    render jsonapi: @checkpoints
  end

  # GET /checkpoints/1
  def show
    CheckpointResource.new.authorize_from_resource_proxy(:read, @checkpoint)
    render jsonapi: @checkpoint
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_checkpoint
    @checkpoint = CheckpointResource.find(params)
  end

  def current_ability
    @current_ability ||= CheckpointAbility.new(@current_user)
  end
end
