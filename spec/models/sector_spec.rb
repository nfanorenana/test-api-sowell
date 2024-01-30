require "rails_helper"
RSpec.describe Sector, type: :model do
  let(:company) { create(:company) }
  let(:place) { create(:place, company: company) }
  let(:sector) { create(:sector, company: company, name: "fakeName") }
  describe "#default sector" do
    it "is valid" do
      expect(sector).to be_valid
    end
  end

  describe "#name" do
    it "is not empty" do
      expect do
        sector.name = nil
        sector.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        sector.name = ""
        sector.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is unique on same company" do
      expect do
        @sector = create(:sector, company: company, name: sector.name)
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "has duplicate values for different companies" do
      another_company = create(:company, name: "another company")
      assert create(:sector, company: another_company, name: sector.name)
    end
  end

  describe "#updated_at" do
    it "is touched on place add to sector" do
      freeze_time
      # We ensure that the updated_at is at the current time first
      expect(sector.updated_at).to eq(DateTime.current)
      travel 5.days do
        sector.places << place
      end
      # Then we check that it gets touched
      expect(sector.updated_at).to eq(DateTime.current + 5.days)
    end

    it "is touched on place delete from sector" do
      freeze_time
      sector.places << place
      expect(sector.updated_at).to eq(DateTime.current)
      travel 5.days do
        sector.places = []
      end
      expect(sector.updated_at).to eq(DateTime.current + 5.days)
    end
  end
end
