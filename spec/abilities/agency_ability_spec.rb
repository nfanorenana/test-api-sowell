require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe AgencyAbility do
  subject(:ability) { AgencyAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:agency) { create(:agency, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Agency)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, agency)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, agency)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, agency)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Agency)
    end
    it "can read his company agency" do
      expect(ability).to be_able_to(:read, agency)
    end
    it "cannot update his company agency" do
      expect(ability).not_to be_able_to(:update, agency)
    end
    it "cannot destroy his company agency" do
      expect(ability).not_to be_able_to(:destroy, agency)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_agency) { create(:agency, company: other_company) }
    it "cannot read other company agency" do
      expect(ability).not_to be_able_to(:read, other_agency)
    end
    it "cannot update other company agency" do
      expect(ability).not_to be_able_to(:update, other_agency)
    end
    it "cannot destroy other company agency" do
      expect(ability).not_to be_able_to(:destroy, other_agency)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Agency)
    end
    it "can read his company agency" do
      expect(ability).to be_able_to(:read, agency)
    end
    it "cannot update his company agency" do
      expect(ability).not_to be_able_to(:update, agency)
    end
    it "cannot destroy his company agency" do
      expect(ability).not_to be_able_to(:destroy, agency)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_agency) { create(:agency, company: other_company) }
    it "cannot read other company agency" do
      expect(ability).not_to be_able_to(:read, other_agency)
    end
    it "cannot update other company agency" do
      expect(ability).not_to be_able_to(:update, other_agency)
    end
    it "cannot destroy other company agency" do
      expect(ability).not_to be_able_to(:destroy, other_agency)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Agency)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, agency)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, agency)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, agency)
    end
  end
end
