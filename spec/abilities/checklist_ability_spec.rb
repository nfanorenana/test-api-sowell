require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe ChecklistAbility do
  subject(:ability) { ChecklistAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:checklist) { create(:checklist, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Checklist)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, Checklist)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, Checklist)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, Checklist)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Checklist)
    end
    it "can read his company checklist" do
      expect(ability).to be_able_to(:read, checklist)
    end
    it "cannot update his company checklist" do
      expect(ability).not_to be_able_to(:update, checklist)
    end
    it "cannot destroy his company checklist" do
      expect(ability).not_to be_able_to(:destroy, checklist)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_checklist) { create(:agency, company: other_company) }
    it "cannot read other company checklist" do
      expect(ability).not_to be_able_to(:read, other_checklist)
    end
    it "cannot update other company checklist" do
      expect(ability).not_to be_able_to(:update, other_checklist)
    end
    it "cannot destroy other company checklist" do
      expect(ability).not_to be_able_to(:destroy, other_checklist)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Checklist)
    end
    it "can read his company checklist" do
      expect(ability).to be_able_to(:read, checklist)
    end
    it "cannot update his company checklist" do
      expect(ability).not_to be_able_to(:update, checklist)
    end
    it "cannot destroy his company checklist" do
      expect(ability).not_to be_able_to(:destroy, checklist)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_checklist) { create(:agency, company: other_company) }
    it "cannot read other company checklist" do
      expect(ability).not_to be_able_to(:read, other_checklist)
    end
    it "cannot update other company checklist" do
      expect(ability).not_to be_able_to(:update, other_checklist)
    end
    it "cannot destroy other company checklist" do
      expect(ability).not_to be_able_to(:destroy, other_checklist)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Checklist)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, checklist)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, checklist)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, checklist)
    end
  end
end
