require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe VisitReportAbility do
  subject(:ability) { VisitReportAbility.new(user) }
  let(:user) { nil }
  let(:visit_report) { create(:visit_report) }
  let(:other_company) { create(:company, name: "Other company") }
  let(:other_company_checklist) { create(:checklist, company: other_company) }
  let(:other_company_visit_schedule) { create(:visit_schedule, checklist: other_company_checklist) }
  let(:other_company_visit_report) { create(:visit_report, visit_schedule: other_company_visit_schedule) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, VisitReport)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, VisitReport)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, VisitReport)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, VisitReport)
    end
  end

  context "an user" do
    let(:user) { visit_report.author }
    it "can create" do
      expect(ability).to be_able_to(:create, visit_report)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, visit_report)
    end
    it "cannot update in his company" do
      expect(ability).not_to be_able_to(:update, visit_report)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, visit_report)
    end

    it "cannot create in other companies" do
      expect(ability).not_to be_able_to(:create, other_company_visit_report)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_visit_report)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_visit_report)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_visit_report)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: visit_report.visit_schedule.place.company) }
    let(:another_visit_report) { create(:visit_report, author: user, visit_schedule: visit_report.visit_schedule) }
    it "can create in his company" do
      expect(ability).to be_able_to(:create, another_visit_report)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, another_visit_report)
    end
    it "cannot update in his company" do
      expect(ability).not_to be_able_to(:update, another_visit_report)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, another_visit_report)
    end

    it "cannot create in other companies" do
      expect(ability).not_to be_able_to(:create, other_company_visit_report)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_visit_report)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_visit_report)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_visit_report)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }
    it "can create" do
      expect(ability).to be_able_to(:create, VisitReport)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, VisitReport)
    end
    it "can update" do
      expect(ability).to be_able_to(:update, VisitReport)
    end
    it "can destroy" do
      expect(ability).to be_able_to(:destroy, VisitReport)
    end
  end
end
