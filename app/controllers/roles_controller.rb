class RolesController < ApplicationController
  before_action :set_role, only: %i[show destroy]

  # GET /roles
  def index
    @roles = RoleResource.all(params)

    render jsonapi: @roles
  end

  # GET /roles/1
  def show
    RoleResource.new.authorize_from_resource_proxy(:read, @role)
    render jsonapi: @role
  end

  # POST /roles
  def create
    @role = RoleResource.build(params)

    if @role.save
      render jsonapi: @role, status: :created
    else
      render jsonapi_errors: @role, status: :unprocessable_entity
    end
  end

  # DELETE /roles/1
  def destroy
    @role.destroy
  end
  private

  # Use callbacks to share common setup or constraints between actions.
  def set_role
    @role = RoleResource.find(params)
  end

  def current_ability
    @current_ability ||= RoleAbility.new(@current_user)
  end
end
