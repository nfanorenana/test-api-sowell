require "rails_helper"
RSpec.describe LocationType, type: :model do
  let(:location_type) { create(:location_type) }
  describe "#default location_type" do
    it "is valid" do
      expect(location_type).to be_valid
    end
  end
  describe "#company" do
    it "is not empty" do
      expect do
        location_type.company_id = nil
        location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        location_type.name = nil
        location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        location_type.name = ""
        location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#nature" do
    it "is a known value" do
      # Known nature
      expect do
        location_type.nature = "housing"
        location_type.save!
      end.not_to raise_error

      # Unknown nature
      expect do
        location_type.nature = "fake_nature"
        location_type.save!
      end.to raise_error(ArgumentError)
    end

    it "is not empty" do
      expect do
        location_type.nature = nil
        location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        location_type.nature = ""
        location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
