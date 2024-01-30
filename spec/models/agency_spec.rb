require "rails_helper"
RSpec.describe Agency, type: :model do
  let(:agency) { create(:agency) }
  describe "#default agency" do
    it "is valid" do
      expect(agency).to be_valid
    end
  end
  describe "#company" do
    it "is not empty" do
      expect do
        agency.company_id = nil
        agency.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        agency.name = nil
        agency.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        agency.name = ""
        agency.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
