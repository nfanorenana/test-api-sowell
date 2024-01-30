# frozen_string_literal: true

require "test_helper"
class ApplicationControllerTest < ActionDispatch::IntegrationTest
  test "includes expected concerns" do
    assert ApplicationController.include?(Tokenable)
    assert ApplicationController.include?(Authorizable)
    # TODO: Remove or replace
    # assert ApplicationController.include?(Serializable)
    assert ApplicationController.include?(Rescueable)
  end
end
