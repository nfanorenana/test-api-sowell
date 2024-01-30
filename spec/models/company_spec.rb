require 'rails_helper'
RSpec.describe Company, :type => :model do

  let(:company) { create(:company) }
  describe "#default company" do
    it "is valid" do
      expect(company).to be_valid
    end
  end

  describe "#name" do
    it "is changeable" do
      company.update(name: "new name")
      company.save!
      company.update(name: "another name")
      company.save!
      expect(company.name).to eq("another name")
    end

    it "is not empty" do
      expect  {
        company.name = nil
        company.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect  {
        company.name = ""
        company.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is unique' do
      expect { 
        create(:company, name: "unique name")
        create(:company, name: "unique name") 
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#default company" do
    it "is valid" do
      expect(company).to be_valid
    end
  end
end