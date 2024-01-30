# frozen_string_literal: true

class SectorsController < ApplicationController
  before_action :set_sector, only: %i[show update destroy add_places delete_places]

  # GET /sectors
  def index
    @sectors = SectorResource.all(params)

    render jsonapi: @sectors
  end

  # GET /sectors/1
  def show
    SectorResource.new.authorize_from_resource_proxy(:read, @sector)
    render jsonapi: @sector
  end

  # POST /sectors
  def create
    custom_params = build_relationships
    @sector = SectorResource.build(custom_params)

    if @sector.save
      render jsonapi: @sector, status: :created
    else
      render jsonapi_errors: @sector, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /sectors/1
  def update
    if @sector.update_attributes
      render jsonapi: @sector
    else
      render jsonapi_errors: @sector, status: :unprocessable_entity
    end
  end

  # DELETE /sectors/1
  def destroy
    @sector.destroy
  end

  # POST /sectors/1/add-places
  def add_places
    SectorResource.new.authorize :update, @sector
    edit_related(Place, "add")
    render json: @sector
  end

  # DELETE /sectors/1/delete-places
  def delete_places
    SectorResource.new.authorize :update, @sector
    edit_related(Place, "delete")
    render json: @sector
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_sector
    @sector = if %i[show update].include?(action_name.to_sym)
                SectorResource.find(params)
              else
                Sector.find(params[:id].to_i)
              end
  end

  def current_ability
    @current_ability ||= sectorAbility.new(@current_user)
  end

  def build_relationships
    if @current_user.admin? && params.dig("data", "relationships", "company").nil?
      params["data"]["relationships"] = {
        "company" => {
          "data" => {
            "type" => "companies",
            "id" => @current_user.company_id.to_s
          }
        }
      }
    end
    params
  end

  def edit_related(model, action)
    instances_to_add_or_remove_ids = params["data"].map { |model| model["id"] }
    current_related_instances = eval("@sector.#{model.to_s.downcase.pluralize}")

    case action
    when "add"
      current_related_instances << model.find(instances_to_add_or_remove_ids)
    when "delete"
      current_related_instances.delete(model.find(instances_to_add_or_remove_ids))
    end
  end
end
