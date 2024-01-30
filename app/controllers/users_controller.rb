# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: %i[show update]

  # GET /users
  def index
    @users = UserResource.all(params)

    render jsonapi: @users
  end

  # GET /users/1
  def show
    UserResource.new.authorize_from_resource_proxy(:read, @user)
    render jsonapi: @user
  end

  # POST /users
  def create
    @user = UserResource.build(params)

    if @user.save
      render jsonapi: @user, status: :created
    else
      render jsonapi_errors: @user, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update_attributes
      render jsonapi: @user
    else
      render jsonapi_errors: @user.errors, status: :unprocessable_entity
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = UserResource.find(params)
  end

  def current_ability
    @current_ability ||= UserAbility.new(@current_user)
  end
end
