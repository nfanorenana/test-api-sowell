require "rspec/expectations"

RSpec::Matchers.define :behave_like_a_jsonapi_collection_response do |expected|
  match do |actual|
    collection = body_as_json
    expect(collection).to behave_like_a_jsonapi_collection
  end
end

RSpec::Matchers.define :behave_like_a_jsonapi_resource_response do |expected|
  match do |actual|
    resource = body_as_json
    expect(resource).to behave_like_a_jsonapi_resource
  end
end
