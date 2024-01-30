require "spec_helper"
require "rails_helper"

RSpec.describe "Rescueable", type: :request do
  before do
    handle_request_exceptions(true)

    klass = Class.new(ActionController::API) do
      include Rescueable

      def fake_unprocessable_entity_raiser
        raise Rescueable::UnprocessableEntity
      end

      def fake_unauthorized_raiser
        raise Rescueable::Unauthorized
      end

      def fake_forbidden_raiser
        raise Rescueable::Forbidden
      end

      def fake_not_found_raiser
        raise Graphiti::Errors::RecordNotFound
      end

      def fake_access_denied_raiser
        raise CanCan::AccessDenied
      end

      def fake_bad_request_raiser
        raise ActionController::BadRequest
      end

      def fake_invalid_include_raiser
        fake_resource = FakeResource.new
        raise Graphiti::Errors::InvalidInclude.new fake_resource, "fake_include"
      end
    end

    stub_const('FakeController', klass)

    # preserve original routes
    Rails.application.routes.disable_clear_and_finalize = true 
    Rails.application.routes.draw do
      get "/unprocessable_entity_raiser" => "fake#fake_unprocessable_entity_raiser"
      get "/unauthorized_raiser" => "fake#fake_unauthorized_raiser"
      get "/forbidden_raiser" => "fake#fake_forbidden_raiser"
      get "/not_found_raiser" => "fake#fake_not_found_raiser"
      get "/bad_request_raiser" => "fake#fake_bad_request_raiser"
      get "/access_denied_raiser" => "fake#fake_access_denied_raiser"
      get "/invalid_include_raiser" => "fake#fake_invalid_include_raiser"
    end
  end

  # Reset routes so they don't include test mapping from above.
  after { Rails.application.reload_routes! }

  it "handles unauthorized error" do
    get "/unauthorized_raiser", as: :json
    
    expect(response).to_not be_successful
    expect(response).to have_http_status(:unauthorized)

    json = JSON.parse(response.body)

    expected_hash = { 
      "code" => "unauthorized",
      "status" => "401",
      "title" => "Unauthorized",
      "detail" => "Cette action requiert une authorisation"
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])

  end

  it "handles unprocessable_entity error" do
      get "/unprocessable_entity_raiser?include=todo", as: :json

      expect(response).to_not be_successful
      expect(response).to have_http_status(:unprocessable_entity)

      json = JSON.parse(response.body)

      expected_hash = { 
        "code" => "unprocessable_entity",
        "status" => "422",
        "title" => "Unprocessable Entity",
        "detail" => "Les paramètres n'ont pas pu être traités"
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])

  end

  it "handles forbidden error" do
    get "/forbidden_raiser", as: :json

    expect(response).to_not be_successful
    expect(response).to have_http_status(:forbidden)

    json = JSON.parse(response.body)

    expected_hash = { 
      "code" => "forbidden",
      "status" => "403",
      "title" => "Forbidden",
      "detail" => "L'utilisateur est reconnu mais ne peut pas réaliser cette action"
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])

  end

  it "handles not_found error" do
    get "/not_found_raiser", as: :json
    
    expect(response).to_not be_successful
    expect(response).to have_http_status(:not_found)

    json = JSON.parse(response.body)

    expected_hash = { 
      "code" => "not_found",
      "status" => "404",
      "title" => "Not Found",
      "detail" => "Specified Record Not Found"
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])
  end

  it "handles access_denied error" do
    get "/access_denied_raiser", as: :json

    expect(response).to_not be_successful
    expect(response).to have_http_status(:forbidden)

    json = JSON.parse(response.body)

    expected_hash = { 
      "code" => "forbidden",
      "status" => "403",
      "title" => "Forbidden",
      "detail" => "You are not authorized to access this page."
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])
  end

  it "handles bad_request error" do
    get "/bad_request_raiser", as: :json

    expect(response).to_not be_successful
    expect(response).to have_http_status(:bad_request)

    json = JSON.parse(response.body)

    expected_hash = { 
      "code" => "bad_request",
      "status" => "400",
      "title" => "Bad Request",
      "detail" => "ActionController::BadRequest"
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])
  end

  it "handles invalid_include error" do
    get "/invalid_include_raiser", as: :json
    
    expect(response).to_not be_successful
    expect(response).to have_http_status(:bad_request)

    json = JSON.parse(response.body)
   
    expected_hash = { 
      "code" => "bad_request",
      "status" => "400",
      "title" => "Bad Request",
      "detail" => "FakeResource: The requested included relationship \"fake_include\" is not supported."
    }

    expect(json["errors"]).to match([
      a_hash_including(expected_hash)
    ])
  end
end