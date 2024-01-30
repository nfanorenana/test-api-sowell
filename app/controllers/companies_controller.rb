# frozen_string_literal: true

class CompaniesController < ApplicationController
  before_action :set_company, only: %i[show update destroy]

  # GET /companies
  def index
    @companies = CompanyResource.all(params)

    render jsonapi: @companies
  end

  # GET /companies/1
  def show
    CompanyResource.new.authorize_from_resource_proxy(:read, @company)
    render jsonapi: @company
  end

  # POST /companies
  def create
    @company = CompanyResource.build(params)

    if @company.save
      render jsonapi: @company, status: :created
    else
      render jsonapi_errors: @company, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /companies/1
  def update
    if @company.update_attributes
      render jsonapi: @company
    else
      render jsonapi_errors: @company, status: :unprocessable_entity
    end
  end

  # DELETE /companies/1
  def destroy
    @company.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_company
    @company = CompanyResource.find(params)
  end

  def current_ability
    @current_ability ||= CompanyAbility.new(@current_user)
  end
end
