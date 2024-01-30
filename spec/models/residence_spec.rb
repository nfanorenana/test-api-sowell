require "rails_helper"
RSpec.describe Residence, type: :model do
  let(:residence) { create(:residence) }
  describe "#default residence" do
    it "is valid" do
      expect(residence).to be_valid
    end
  end
  describe "#company" do
    it "is not empty" do
      expect do
        residence.company_id = nil
        residence.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        residence.name = nil
        residence.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        residence.name = ""
        residence.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#agency" do
    it "is not empty" do
      expect do
        residence.agency_id = nil
        residence.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
