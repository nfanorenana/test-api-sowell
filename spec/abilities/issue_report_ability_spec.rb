require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe IssueReportAbility do
  subject(:ability) { IssueReportAbility.new(user) }
  let(:user) { nil }
  let(:issue_report) { create(:issue_report) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, IssueReport)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, IssueReport)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, IssueReport)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, IssueReport)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: issue_report.company) }
    it "can create" do
      expect(ability).to be_able_to(:create, issue_report)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, issue_report)
    end
    it "can update in his company" do
      expect(ability).to be_able_to(:update, issue_report)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, issue_report)
    end

    let(:other_company) { create(:company, name: "Other company") }
    let(:other_company_issue_report) { create(:issue_report, company: other_company) }
    it "cannot create in other companies" do
      expect(ability).not_to be_able_to(:create, other_company_issue_report)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_issue_report)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_issue_report)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_issue_report)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: issue_report.company) }
    it "can create in his company" do
      expect(ability).to be_able_to(:create, issue_report)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, issue_report)
    end
    it "can update in his company" do
      expect(ability).to be_able_to(:update, issue_report)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, issue_report)
    end

    let(:other_company) { create(:company, name: "Other company") }
    let(:other_company_issue_report) { create(:issue_report, company: other_company) }
    it "cannot create in other companies" do
      expect(ability).not_to be_able_to(:create, other_company_issue_report)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_issue_report)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_issue_report)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_issue_report)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }
    it "can create" do
      expect(ability).to be_able_to(:create, IssueReport)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, IssueReport)
    end
    it "can update" do
      expect(ability).to be_able_to(:update, IssueReport)
    end
    it "can destroy" do
      expect(ability).to be_able_to(:destroy, IssueReport)
    end
  end
end
