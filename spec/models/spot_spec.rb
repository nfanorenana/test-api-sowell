require "rails_helper"
RSpec.describe Spot, type: :model do
  let(:place) { create(:place) }
  let(:spot) { create(:spot, place: place) }

  describe "#default spot" do
    it "is valid" do
      expect(spot).to be_valid
    end
  end

  describe "#place" do
    it "is not empty" do
      expect do
        spot.place_id = nil
        spot.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    let(:another_company) { create(:company) }
    let(:another_company_place) { create(:place, company: another_company) }
    it "is from the same company as the location_type" do
      expect do
        spot.place = another_company_place
        spot.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#location_type" do
    it "is not empty" do
      expect do
        spot.location_type = nil
        spot.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#name" do
    it "is not empty" do
      expect do
        spot.name = nil
        spot.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        spot.name = ""
        spot.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
