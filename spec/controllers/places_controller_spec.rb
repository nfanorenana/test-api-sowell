require "spec_helper"
require "rails_helper"

RSpec.describe PlacesController, type: :request do
  context "a superadmin" do
    let(:superadmin) { create(:superadmin) }
    let!(:place) { create(:place) }

    it "list places" do
      get places_url, headers: authorization_header(superadmin), as: :json
      expect(response).to have_http_status(:success)

      collection = body_as_json

      expect(collection).to behave_like_a_jsonapi_collection
      expect(collection["data"].first).to have_type(:places)
      expect(collection["data"].size).to eq(1)
    end

    it "show place" do
      get place_url(place), headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      resource = body_as_json

      expect(resource).to behave_like_a_jsonapi_resource
      expect(resource["data"]).to have_attribute(:name).with_value(place.name)
    end

    it "can GET on /places?filter[city]=CITY&include=company" do
      place_to_filter = create(:place)
      get "#{places_url}?filter[city]=#{place_to_filter.city}&include=company",
          headers: authorization_header(superadmin), as: :json

      expect(response).to have_http_status(:success)

      collection = body_as_json
      expect(collection["data"].size).to eq(1)
      expect(collection["data"][0]["attributes"]["city"]).to eq(place_to_filter.city)
    end
  end
end
