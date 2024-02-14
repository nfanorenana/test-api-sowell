class ExportsController < ApplicationController
  before_action :set_export, only: %i[ show ]

  # GET /exports
  def index
    @exports = Export.select(:name, :status, :url).where(status: 2)

    render jsonapi: @exports
  end

  # GET /exports/1
  def show
    render jsonapi: @export
  end

  # POST /exports
  def create
    @export = ExportResource.build(params)

    if @export.save
      render jsonapi: @export, status: :created
    else
      render jsonapi_errors: @export, status: :unprocessable_entity
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_export
    @export = ExportResource.find(params)
  end

  def current_ability
    @current_ability ||= ExportAbility.new(@current_user)
  end
end
