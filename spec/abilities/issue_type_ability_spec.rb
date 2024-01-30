require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe IssueTypeAbility do
  subject(:ability) { IssueTypeAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:location_type) { create(:location_type, company: company) }
  let(:issue_type) { create(:issue_type, company: company, location_type: location_type) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, IssueType)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, issue_type)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, issue_type)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, issue_type)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, IssueType)
    end
    it "can read his company issue_type" do
      expect(ability).to be_able_to(:read, issue_type)
    end
    it "cannot update his company issue_type" do
      expect(ability).not_to be_able_to(:update, issue_type)
    end
    it "cannot destroy his company issue_type" do
      expect(ability).not_to be_able_to(:destroy, issue_type)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_location_type) { create(:location_type, company: other_company) }
    let(:other_issue_type) { create(:issue_type, company: other_company, location_type: other_location_type) }
    it "cannot read other company issue_type" do
      expect(ability).not_to be_able_to(:read, other_issue_type)
    end
    it "cannot update other company issue_type" do
      expect(ability).not_to be_able_to(:update, other_issue_type)
    end
    it "cannot destroy other company issue_type" do
      expect(ability).not_to be_able_to(:destroy, other_issue_type)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, IssueType)
    end
    it "can read his company issue_type" do
      expect(ability).to be_able_to(:read, issue_type)
    end
    it "cannot update his company issue_type" do
      expect(ability).not_to be_able_to(:update, issue_type)
    end
    it "cannot destroy his company issue_type" do
      expect(ability).not_to be_able_to(:destroy, issue_type)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_location_type) { create(:location_type, company: other_company) }
    let(:other_issue_type) { create(:issue_type, company: other_company, location_type: other_location_type) }
    it "cannot read other company issue_type" do
      expect(ability).not_to be_able_to(:read, other_issue_type)
    end
    it "cannot update other company issue_type" do
      expect(ability).not_to be_able_to(:update, other_issue_type)
    end
    it "cannot destroy other company issue_type" do
      expect(ability).not_to be_able_to(:destroy, other_issue_type)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, IssueType)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, issue_type)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, issue_type)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, issue_type)
    end
  end
end
