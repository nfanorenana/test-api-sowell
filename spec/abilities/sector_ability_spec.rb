require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe SectorAbility do
  subject(:ability) { SectorAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:sector) { create(:sector, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Sector)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, Sector)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, Sector)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, Sector)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Sector)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, sector)
    end
    it "cannot update in his company" do
      expect(ability).not_to be_able_to(:update, sector)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, sector)
    end

    let (:other_company) { create(:company, name: "Other company") }
    let(:other_company_sector) { create(:sector, company: other_company) }
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_sector)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_sector)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_sector)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: company) }
    it "can create in his company" do
      expect(ability).to be_able_to(:create, sector)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, sector)
    end
    it "can update in his company" do
      expect(ability).to be_able_to(:update, sector)
    end
    it "can destroy in his company" do
      expect(ability).to be_able_to(:destroy, sector)
    end

    let (:other_company) { create(:company, name: "Other company") }
    let(:other_company_sector) { create(:sector, company: other_company) }
    it "cannot create in other companies" do
      expect(ability).not_to be_able_to(:create, other_company_sector)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_sector)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_sector)
    end
    it "cannot destroy in other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company_sector)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }
    it "can create" do
      expect(ability).to be_able_to(:create, Sector)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, Sector)
    end
    it "can update" do
      expect(ability).to be_able_to(:update, Sector)
    end
    it "can destroy" do
      expect(ability).to be_able_to(:destroy, Sector)
    end
  end
end
