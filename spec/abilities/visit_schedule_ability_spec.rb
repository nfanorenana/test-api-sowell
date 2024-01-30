require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe VisitScheduleAbility do
  subject(:ability) { VisitScheduleAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:checklist) { create(:checklist, company: company) }
  let(:visit_schedule) { create(:visit_schedule, checklist: checklist) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, VisitSchedule)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, visit_schedule)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, visit_schedule)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, visit_schedule)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, VisitSchedule)
    end
    it "can read his company visit_schedule" do
      expect(ability).to be_able_to(:read, visit_schedule)
    end
    it "cannot update his company visit_schedule" do
      expect(ability).not_to be_able_to(:update, visit_schedule)
    end
    it "cannot destroy his company visit_schedule" do
      expect(ability).not_to be_able_to(:destroy, visit_schedule)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_checklist) { create(:checklist, company: other_company) }
    let(:other_visit_schedule) { create(:visit_schedule, checklist: other_checklist) }
    it "cannot read other company visit_schedule" do
      expect(ability).not_to be_able_to(:read, other_visit_schedule)
    end
    it "cannot update other company visit_schedule" do
      expect(ability).not_to be_able_to(:update, other_visit_schedule)
    end
    it "cannot destroy other company visit_schedule" do
      expect(ability).not_to be_able_to(:destroy, other_visit_schedule)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, VisitSchedule)
    end
    it "can read his company visit_schedule" do
      expect(ability).to be_able_to(:read, visit_schedule)
    end
    it "cannot update his company visit_schedule" do
      expect(ability).not_to be_able_to(:update, visit_schedule)
    end
    it "cannot destroy his company visit_schedule" do
      expect(ability).not_to be_able_to(:destroy, visit_schedule)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_checklist) { create(:checklist, company: other_company) }
    let(:other_visit_schedule) { create(:visit_schedule, checklist: other_checklist) }
    it "cannot read other company visit_schedule" do
      expect(ability).not_to be_able_to(:read, other_visit_schedule)
    end
    it "cannot update other company visit_schedule" do
      expect(ability).not_to be_able_to(:update, other_visit_schedule)
    end
    it "cannot destroy other company visit_schedule" do
      expect(ability).not_to be_able_to(:destroy, other_visit_schedule)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, VisitSchedule)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, visit_schedule)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, visit_schedule)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, visit_schedule)
    end
  end
end
