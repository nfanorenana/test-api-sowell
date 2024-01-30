# frozen_string_literal: true

require "test_helper"

class SectorTest < ActiveSupport::TestCase
  context "#name" do
    should "not be empty" do
      company = create(:company)
      sector = build(:sector, company: company, name: nil)
      assert_raise(ActiveRecord::RecordInvalid) do
        sector.save!
      end
      assert sector.errors.first.attribute == :name
      assert sector.errors.first.type == :blank
    end

    should "be unique on same company" do
      company = create(:company)
      existing_sector = create(:sector, company: company)
      sector = build(:sector, company: company, name: existing_sector.name)
      assert_raise(ActiveRecord::RecordInvalid) do
        sector.save!
      end
      assert sector.errors.first.attribute == :name
      assert sector.errors.first.type == :taken
    end

    should "have duplicate values for different companies" do
      first_company = create(:company)
      existing_sector = create(:sector, company: first_company)
      second_company = create(:company, name: "another company")
      sector = build(:sector, company: second_company, name: existing_sector.name)
      assert sector.save!
    end
  end
end
