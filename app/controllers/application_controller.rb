# frozen_string_literal: true

class ApplicationController < ActionController::API
  include Tokenable
  # TODO: Remove or replace
  # include Serializable
  include Rescueable

  attr_reader :current_user
end
