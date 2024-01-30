# frozen_string_literal: true

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"
require "shoulda-context"

require "database_cleaner/active_record"
require "json_web_token"

DatabaseCleaner.strategy = :transaction

module AroundEachTest
  def before_setup
    super
    DatabaseCleaner.clean
    DatabaseCleaner.start
    handle_request_exceptions(true)
  end
end

module Minitest
  class Test
    include ActiveSupport::Testing::TimeHelpers
    include FactoryBot::Syntax::Methods
    include AroundEachTest
    include Graphiti::Rails::TestHelpers
  end
end

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: ENV["PARALLEL_WORKERS"] || :number_of_processors)

    # Add more helper methods to be used by all tests here...

    def authorization_header(user)
      return unless user

      token = JsonWebToken.encode({ uid: user.id })
      {
        Authorization: "Bearer #{token}"
      }
    end

    def assert_jsonapi_collection_response
      collection = Oj.load(response.body)
      assert_includes(collection, "data")
      assert_kind_of(Array, collection["data"])

      assert_includes_jsonapi_props collection["data"].first if collection["data"].size
    end

    def assert_jsonapi_ressource_response
      ressource = Oj.load(response.body)
      assert_includes(ressource, "data")

      assert_includes_jsonapi_props ressource["data"]
    end

    def assert_includes_jsonapi_props(data)
      assert_kind_of(Hash, data)
      assert_includes(data, "id")
      assert_includes(data, "attributes")
    end
  end
end
