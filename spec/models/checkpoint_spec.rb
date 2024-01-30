require "rails_helper"

RSpec.describe Checkpoint, type: :model do
  let(:checkpoint) { create(:checkpoint) }
  let(:checklist) { checkpoint.checklist }
  let(:other_company) { create(:company) }
  let(:other_issue_type) { create(:issue_type, company: other_company) }
  let(:other_checklist) { create(:checklist, company: other_company) }

  describe "#default checkpoint" do
    it "is valid" do
      expect(checkpoint).to be_valid
    end
  end

  describe "#checklist" do
    it "is not empty" do
      expect do
        checkpoint.checklist_id = nil
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the company" do
      expect do
        checkpoint.checklist_id = other_checklist
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "is touched on checkpoint create or destroy" do
      freeze_time
      # We ensure that the updated_at is at the current time first
      expect(checklist.updated_at).to eq(DateTime.current)
      # On create
      travel 5.days do
        create(:checkpoint, issue_type: checkpoint.issue_type, checklist: checklist)
      end
      # Then we check that it gets touched
      expect(checklist.updated_at).to eq(DateTime.current + 5.days)

      # On destroy
      travel 10.days do
        Checkpoint.last.destroy
      end
      checklist.reload
      expect(checklist.updated_at).to eq(DateTime.current + 10.days)
    end
  end

  describe "#issue_type" do
    it "is not empty" do
      expect do
        checkpoint.issue_type = nil
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    it "belongs to the company" do
      expect do
        checkpoint.issue_type = other_issue_type
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#question" do
    it "is not empty" do
      expect do
        checkpoint.question = nil
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        checkpoint.question = ""
        checkpoint.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#default checkpoint" do
    it "is valid" do
      expect(checkpoint).to be_valid
    end
  end
end
