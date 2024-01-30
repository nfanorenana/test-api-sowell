# frozen_string_literal: true

require "test_helper"

class CompanyTest < ActiveSupport::TestCase
  context "#name" do
    setup do
      @company = build(:company)
    end
    should "be changeable" do
      @company.name = "new name"
      assert @company.save
      @company.name = "another name"
      assert @company.save
    end

    should "not be empty" do
      @company.name = nil
      assert_not @company.save
      assert_equal I18n.t("validations.common.name_presence"), @company.errors[:name].first

      @company.name = ""
      assert_not @company.save
      assert_equal I18n.t("validations.common.name_presence"), @company.errors[:name].first
    end

    should "be unique" do
      create(:company)
      assert_not @company.save
      assert_equal @company.errors[:name].first, "has already been taken"
    end
  end
end
