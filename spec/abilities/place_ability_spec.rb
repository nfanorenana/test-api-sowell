require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe PlaceAbility do
  subject(:ability) { PlaceAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:agency) { create(:agency, company: company) }
  let(:residence) { create(:residence, agency: agency, company: company) }
  let(:place) { create(:place, residence: residence, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Place)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, place)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, place)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, place)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Place)
    end
    it "can read his company place" do
      expect(ability).to be_able_to(:read, place)
    end
    it "cannot update his company place" do
      expect(ability).not_to be_able_to(:update, place)
    end
    it "cannot destroy his company place" do
      expect(ability).not_to be_able_to(:destroy, place)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_agency) { create(:agency, name: "other agency", company: other_company) }
    let(:other_residence) { create(:residence, name: "other residence", agency: other_agency, company: other_company) }
    let(:other_place) { create(:place, residence: other_residence, company: other_company) }
    it "cannot read other company place" do
      expect(ability).not_to be_able_to(:read, other_place)
    end
    it "cannot update other company place" do
      expect(ability).not_to be_able_to(:update, other_place)
    end
    it "cannot destroy other company place" do
      expect(ability).not_to be_able_to(:destroy, other_place)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Place)
    end
    it "can read his company place" do
      expect(ability).to be_able_to(:read, place)
    end
    it "cannot update his company place" do
      expect(ability).not_to be_able_to(:update, place)
    end
    it "cannot destroy his company place" do
      expect(ability).not_to be_able_to(:destroy, place)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_agency) { create(:agency, name: "other agency", company: other_company) }
    let(:other_residence) { create(:residence, name: "other residence", agency: other_agency, company: other_company) }
    let(:other_place) { create(:place, residence: other_residence, company: other_company) }
    it "cannot read other company place" do
      expect(ability).not_to be_able_to(:read, other_place)
    end
    it "cannot update other company place" do
      expect(ability).not_to be_able_to(:update, other_place)
    end
    it "cannot destroy other company place" do
      expect(ability).not_to be_able_to(:destroy, other_place)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Place)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, place)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, place)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, place)
    end
  end
end
