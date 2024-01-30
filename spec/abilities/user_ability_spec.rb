require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe UserAbility do
  subject(:ability) { UserAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, User)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, User)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, User)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, User)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    let(:user_in_company) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, User)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, user_in_company)
    end
    it "can update himself" do
      expect(ability).to be_able_to(:update, user)
    end
    it "cannot update another user in his company" do
      expect(ability).not_to be_able_to(:update, user_in_company)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, user_in_company)
    end

    let!(:other_company_user) { create(:company, name: "other company") }
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_user)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_user)
    end
    it "cannot destroy in other company" do
      expect(ability).not_to be_able_to(:destroy, other_company_user)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }
    let(:user_in_company) { create(:user, company: company) }
    it "can create in his company" do
      expect(ability).to be_able_to(:create, user_in_company)
    end
    it "can read in his company" do
      expect(ability).to be_able_to(:read, user_in_company)
    end
    it "can update in his company" do
      expect(ability).to be_able_to(:update, user_in_company)
    end
    it "cannot destroy in his company" do
      expect(ability).not_to be_able_to(:destroy, user_in_company)
    end

    let!(:other_company_user) { create(:company, name: "other company") }
    it "cannot create in his company" do
      expect(ability).not_to be_able_to(:create, other_company_user)
    end
    it "cannot read in other companies" do
      expect(ability).not_to be_able_to(:read, other_company_user)
    end
    it "cannot update in other companies" do
      expect(ability).not_to be_able_to(:update, other_company_user)
    end
    it "cannot destroy in other company" do
      expect(ability).not_to be_able_to(:destroy, other_company_user)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }
    it "can create" do
      expect(ability).to be_able_to(:create, User)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, User)
    end
    it "can update" do
      expect(ability).to be_able_to(:update, User)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, User)
    end
  end
end
