require "rails_helper"

RSpec.describe IssueReport, type: :model do
  let(:company) { create(:company) }
  let(:place) { create(:place, company: company) }
  let(:spot) { create(:spot, place: place) }
  let(:same_company_place) { create(:place, company: company) }
  let(:same_company_spot) { create(:spot, place: same_company_place) }

  let(:other_spot) { create(:spot, spot: place) }
  let(:location_type) { create(:location_type, company: company) }
  let(:issue_type) { create(:issue_type, company: company, location_type: location_type) }

  let(:issue_report) { create(:issue_report, company: company, place: place, issue_type: issue_type) }

  let(:other_company) { create(:company) }
  let(:other_place) { create(:place, company: other_company) }
  let(:other_spot) { create(:spot, place: other_place) }
  let(:other_location_type) { create(:location_type, company: other_company) }
  let(:other_issue_type) { create(:issue_type, company: other_company, location_type: other_location_type) }

  describe "by default" do
    it "is valid" do
      expect(issue_report).to be_valid
    end
  end

  describe "with housing related issue_type" do
    it "has a spot" do
      issue_report.issue_type.location_type.update!(nature: "housing")
      expect do
        issue_report.spot_id = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#company" do
    it "is not empty" do
      expect do
        issue_report.company_id = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#place" do
    it "is not empty" do
      expect do
        issue_report.place_id = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the company" do
      expect do
        issue_report.place = other_place
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#issue_type" do
    it "is not empty" do
      expect do
        issue_report.issue_type = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the company" do
      expect do
        issue_report.issue_type = other_issue_type
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#message" do
    it "is not empty" do
      expect do
        issue_report.message = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        issue_report.message = ""
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#author" do
    it "is not empty" do
      expect do
        issue_report.author = nil
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#spot" do
    it "can be empty if issue_type is not housing related" do
      expect do
        issue_report.spot_id = nil
        issue_report.save!
      end.not_to raise_error
    end

    it "is related to place" do
      # Same company but the spot does not belong to the place
      expect do
        issue_report.spot = same_company_spot
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      # Different company and the spot does not belong to the place
      expect do
        issue_report.spot = other_spot
        issue_report.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#status" do
    context "on update" do
      it "update status timestamp" do
        travel_to DateTime.now - 2.hours
        freeze_time do
          issue_report.update(status: "ongoing")
          assert_equal issue_report.ongoing_timestamp, issue_report.updated_at
        end

        travel_to DateTime.now + 1.hour
        freeze_time do
          issue_report.update(status: "done")
          assert_equal issue_report.done_timestamp, issue_report.updated_at
        end

        travel_to DateTime.now + 2.hours
        freeze_time do
          issue_report.update(status: "ongoing")
          assert_equal issue_report.ongoing_timestamp, issue_report.updated_at
          assert_nil issue_report.done_timestamp
          assert_nil issue_report.canceled_timestamp
        end

        travel_to DateTime.now + 5.hours
        freeze_time do
          issue_report.update(status: "pending")
          assert_equal issue_report.pending_timestamp, issue_report.updated_at
          assert_nil issue_report.done_timestamp
          assert_nil issue_report.ongoing_timestamp
          assert_nil issue_report.canceled_timestamp
        end
      end
    end
  end

  describe "#talks" do
    context "message" do
      it "is not empty" do
        expect do
          issue_report.talks = [{ message: "" }]
          issue_report.save!
        end.to raise_error(ActiveRecord::RecordInvalid)
      end

      it "is a string" do
        expect do
          issue_report.talks = [{ message: 123 }]
          issue_report.save!
        end.to raise_error(ActiveRecord::RecordInvalid)

        expect do
          issue_report.talks = [{ message: [] }]
          issue_report.save!
        end.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
