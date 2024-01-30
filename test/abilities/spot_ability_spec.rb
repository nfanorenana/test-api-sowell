require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe SpotAbility do
  subject(:ability) { SpotAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:place) { create(:place, company: company) }
  let(:spot) { create(:spot, place: place) }

  let(:other_company) { create(:company, name: "other company") }
  let(:other_place) { create(:place, company: other_company) }
  let(:other_spot) { create(:spot, place: other_place) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Spot)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, spot)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, spot)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, spot)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Spot)
    end
    it "can read his company spot" do
      expect(ability).to be_able_to(:read, spot)
    end
    it "cannot update his company spot" do
      expect(ability).not_to be_able_to(:update, spot)
    end
    it "cannot destroy his company spot" do
      expect(ability).not_to be_able_to(:destroy, spot)
    end

    it "cannot read other company spot" do
      expect(ability).not_to be_able_to(:read, other_spot)
    end
    it "cannot update other company spot" do
      expect(ability).not_to be_able_to(:update, other_spot)
    end
    it "cannot destroy other company spot" do
      expect(ability).not_to be_able_to(:destroy, other_spot)
    end
  end

  context "an admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Spot)
    end
    it "can read his company spot" do
      expect(ability).to be_able_to(:read, spot)
    end
    it "cannot update his company spot" do
      expect(ability).not_to be_able_to(:update, spot)
    end
    it "cannot destroy his company spot" do
      expect(ability).not_to be_able_to(:destroy, spot)
    end

    it "cannot read other company spot" do
      expect(ability).not_to be_able_to(:read, other_spot)
    end
    it "cannot update other company spot" do
      expect(ability).not_to be_able_to(:update, other_spot)
    end
    it "cannot destroy other company spot" do
      expect(ability).not_to be_able_to(:destroy, other_spot)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Spot)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, spot)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, spot)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, spot)
    end
  end
end
