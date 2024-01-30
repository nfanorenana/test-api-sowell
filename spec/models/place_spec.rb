require "rails_helper"
RSpec.describe Place, type: :model do
  let(:place) { create(:place) }
  let(:sector) { create(:sector, company: place.company) }

  describe "#default place" do
    it "is valid" do
      expect(place).to be_valid
    end
  end

  describe "#company" do
    it "is not empty" do
      expect do
        place.company_id = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#name" do
    it "is not empty" do
      expect do
        place.name = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        place.name = ""
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#residence" do
    it "is not empty" do
      expect do
        place.residence_id = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#zip" do
    it "is not empty" do
      expect do
        place.zip = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#city" do
    it "is not empty" do
      expect do
        place.city = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#country" do
    it "is not empty" do
      expect do
        place.country = nil
        place.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#updated_at" do
    it "is touched on visit_schedule create and destroy" do
      freeze_time
      # We ensure that the updated_at is at the current time first
      expect(place.updated_at).to eq(DateTime.current)
      # On create
      travel 5.days do
        checklist = create(:checklist, company: place.company)
        create(:visit_schedule, place: place, checklist: checklist)
      end
      # Then we check that it gets touched
      expect(place.updated_at).to eq(DateTime.current + 5.days)

      # On destroy
      travel 10.days do
        VisitSchedule.last.destroy
      end
      place.reload
      expect(place.updated_at).to eq(DateTime.current + 10.days)
    end

    it "is touched on spot create and destroy" do
      freeze_time
      expect(place.updated_at).to eq(DateTime.current)
      # On create
      travel 5.days do
        create(:spot, place: place)
      end
      expect(place.updated_at).to eq(DateTime.current + 5.days)

      # On destroy
      travel 10.days do
        Spot.last.destroy
      end
      place.reload
      expect(place.updated_at).to eq(DateTime.current + 10.days)
    end

    it "is touched on residence update" do
      freeze_time
      expect(place.updated_at).to eq(DateTime.current)
      travel 5.days do
        place.residence.update(name: "Something else")
      end

      place.reload
      expect(place.updated_at).to eq(DateTime.current + 5.days)
    end

    it "is touched on agency update" do
      freeze_time
      expect(place.updated_at).to eq(DateTime.current)
      travel 5.days do
        place.residence.agency.update(name: "Something else")
      end

      place.reload
      expect(place.updated_at).to eq(DateTime.current + 5.days)
    end
  end

  describe "#sector" do
    context "updated_at" do
      it "is touched on place destroy" do
        freeze_time
        sector.places << place
        expect(sector.updated_at).to eq(DateTime.current)
        travel 5.days do
          place.destroy
        end
        sector.reload
        expect(sector.updated_at).to eq(DateTime.current + 5.days)
      end
    end
  end
end
