require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe ResidenceAbility do
  subject(:ability) { ResidenceAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:agency) { create(:agency, company: company) }
  let(:residence) { create(:residence, agency: agency, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Residence)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, residence)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, residence)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, residence)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Residence)
    end
    it "can read his company residence" do
      expect(ability).to be_able_to(:read, residence)
    end
    it "cannot update his company residence" do
      expect(ability).not_to be_able_to(:update, residence)
    end
    it "cannot destroy his company residence" do
      expect(ability).not_to be_able_to(:destroy, residence)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_residence) { create(:agency, company: other_company) }
    it "cannot read other company residence" do
      expect(ability).not_to be_able_to(:read, other_residence)
    end
    it "cannot update other company residence" do
      expect(ability).not_to be_able_to(:update, other_residence)
    end
    it "cannot destroy other company residence" do
      expect(ability).not_to be_able_to(:destroy, other_residence)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Residence)
    end
    it "can read his company residence" do
      expect(ability).to be_able_to(:read, residence)
    end
    it "cannot update his company residence" do
      expect(ability).not_to be_able_to(:update, residence)
    end
    it "cannot destroy his company residence" do
      expect(ability).not_to be_able_to(:destroy, residence)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_residence) { create(:agency, company: other_company) }
    it "cannot read other company residence" do
      expect(ability).not_to be_able_to(:read, other_residence)
    end
    it "cannot update other company residence" do
      expect(ability).not_to be_able_to(:update, other_residence)
    end
    it "cannot destroy other company residence" do
      expect(ability).not_to be_able_to(:destroy, other_residence)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Residence)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, residence)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, residence)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, residence)
    end
  end
end
