require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe CompanyAbility do
  subject(:ability) { CompanyAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Company)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, Company)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, Company)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, Company)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Company)
    end
    it "can read his company" do
      expect(ability).to be_able_to(:read, company)
    end
    it "cannot update his company" do
      expect(ability).not_to be_able_to(:update, company)
    end
    it "cannot destroy his company" do
      expect(ability).not_to be_able_to(:destroy, company)
    end

    let(:other_company) { create(:company, name: "other company") }
    it "cannot read other companies" do
      expect(ability).not_to be_able_to(:read, other_company)
    end
    it "cannot update other companies" do
      expect(ability).not_to be_able_to(:update, other_company)
    end
    it "cannot destroy other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Company)
    end
    it "can read his company" do
      expect(ability).to be_able_to(:read, company)
    end
    it "can update his company" do
      expect(ability).to be_able_to(:update, company)
    end
    it "cannot destroy his company" do
      expect(ability).not_to be_able_to(:destroy, company)
    end

    let(:other_company) { create(:company, name: "other company") }
    it "cannot read other companies" do
      expect(ability).not_to be_able_to(:read, other_company)
    end
    it "cannot update other companies" do
      expect(ability).not_to be_able_to(:update, other_company)
    end
    it "cannot destroy other companies" do
      expect(ability).not_to be_able_to(:destroy, other_company)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }
    it "can create" do
      expect(ability).to be_able_to(:create, Company)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, Company)
    end
    it "can update" do
      expect(ability).to be_able_to(:update, Company)
    end
    it "can destroy" do
      expect(ability).to be_able_to(:destroy, Company)
    end
  end
end
