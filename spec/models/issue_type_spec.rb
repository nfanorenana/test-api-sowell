require "rails_helper"
RSpec.describe IssueType, type: :model do
  let(:base_location_type) { create(:base_location_type) }
  let(:base_issue_type) { create(:base_issue_type, base_location_type: base_location_type) }
  let(:company) { create(:company) }
  let(:location_type) { create(:location_type, base_location_type: base_location_type, company: company) }
  let(:issue_type) { create(:issue_type, base_issue_type: base_issue_type, location_type: location_type, company: company) }

  describe "#default issue_type" do
    it "is valid" do
      expect(issue_type).to be_valid
    end
  end

  describe "#company" do
    it "is not empty" do
      expect do
        issue_type.company_id = nil
        issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#location_type" do
    it "is not empty" do
      expect do
        issue_type.location_type = nil
        issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end

    let(:other_company) { create(:company) }
    let(:other_location_type) { create(:location_type, company: other_company) }
    it "belongs to the company" do
      expect do
        issue_type.location_type = other_location_type
        issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        issue_type.name = nil
        issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        issue_type.name = ""
        issue_type.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
