# frozen_string_literal: true

require "rails_helper"
require "spec_helper"
require "cancan/matchers"

Rspec.describe ExportAbility do
  subject(:ability) { ExportAbility.new(user) }
  let(:user) { nil }
  let(:company) { create(:export) }

  context 'a guest' do
    it "cannot create" do
      expect(ability).not_to be_able_to(:create, Export)
    end
    it "cannot read" do
      expect(ability).not_to be_able_to(:read, Export)
    end
    it "cannot update" do
      expect(ability).not_to be_able_to(:update, Export)
    end
    it "cannot destroy" do
      expect(ability).not_to be_able_to(:destroy, Export)
    end
  end
end
