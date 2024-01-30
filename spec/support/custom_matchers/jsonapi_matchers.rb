require "rspec/expectations"

RSpec::Matchers.define :include_a_jsonapi_props do |expected|
  match do |actual|
    expect(actual).to be_a_kind_of(Hash)
    expect(actual).to include("id")
    expect(actual).to include("attributes")
  end
end

RSpec::Matchers.define :behave_like_a_jsonapi_collection do |expected|
  match do |actual|
    expect(actual).to include("data")
    expect(actual["data"]).to be_a_kind_of(Array)
    expect(actual["data"].first).to include_a_jsonapi_props if actual["data"].size
  end
end

RSpec::Matchers.define :behave_like_a_jsonapi_resource do |expected|
  match do |actual|
    expect(actual).to include("data")
    expect(actual["data"]).to include_a_jsonapi_props
  end
end
