require "rails_helper"
RSpec.describe BaseLocationType, type: :model do
  let(:base_location_type) { create(:base_location_type) }
  describe "#name" do
    it "is not empty" do
      expect do
        base_location_type.name = ""
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#depth_level" do
    it "is not empty" do
      expect do
        base_location_type.depth_level = ""
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is invalid with unauthorized value" do
      expect do
        base_location_type.depth_level = 'unknown'
        base_location_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
