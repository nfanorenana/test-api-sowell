require "rails_helper"
require "spec_helper"
require "cancan/matchers"

RSpec.describe LocationTypeAbility do
  subject(:ability) { LocationTypeAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:company) }
  let(:location_type) { create(:location_type, company: company) }

  context "a guest" do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, LocationType)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, location_type)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, location_type)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, location_type)
    end
  end

  context "an user" do
    let(:user) { create(:user, company: company) }
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, LocationType)
    end
    it "can read his company location_type" do
      expect(ability).to be_able_to(:read, location_type)
    end
    it "cannot update his company location_type" do
      expect(ability).not_to be_able_to(:update, location_type)
    end
    it "cannot destroy his company location_type" do
      expect(ability).not_to be_able_to(:destroy, location_type)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_location_type) { create(:location_type, company: other_company) }
    it "cannot read other company location_type" do
      expect(ability).not_to be_able_to(:read, other_location_type)
    end
    it "cannot update other company location_type" do
      expect(ability).not_to be_able_to(:update, other_location_type)
    end
    it "cannot destroy other company location_type" do
      expect(ability).not_to be_able_to(:destroy, other_location_type)
    end
  end

  context "a admin" do
    let(:user) { create(:admin, company: company) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, LocationType)
    end
    it "can read his company location_type" do
      expect(ability).to be_able_to(:read, location_type)
    end
    it "cannot update his company location_type" do
      expect(ability).not_to be_able_to(:update, location_type)
    end
    it "cannot destroy his company location_type" do
      expect(ability).not_to be_able_to(:destroy, location_type)
    end

    let(:other_company) { create(:company, name: "other company") }
    let(:other_location_type) { create(:location_type, company: other_company) }
    it "cannot read other company location_type" do
      expect(ability).not_to be_able_to(:read, other_location_type)
    end
    it "cannot update other company location_type" do
      expect(ability).not_to be_able_to(:update, other_location_type)
    end
    it "cannot destroy other company location_type" do
      expect(ability).not_to be_able_to(:destroy, other_location_type)
    end
  end

  context "a superadmin" do
    let(:user) { create(:superadmin, company: nil) }

    it "cannot create" do
      expect(ability).not_to be_able_to(:create, LocationType)
    end
    it "can read" do
      expect(ability).to be_able_to(:read, location_type)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, location_type)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, location_type)
    end
  end
end
