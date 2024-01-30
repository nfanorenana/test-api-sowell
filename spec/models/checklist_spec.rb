require "rails_helper"
RSpec.describe LocationType, type: :model do
  let(:checklist) { create(:checklist) }
  describe "#default checklist" do
    it "is valid" do
      expect(checklist).to be_valid
    end
  end
  describe "#company" do
    it "is not empty" do
      expect do
        checklist.company_id = nil
        checklist.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#name" do
    it "is not empty" do
      expect do
        checklist.name = nil
        checklist.save!
      end.to raise_error(ActiveRecord::RecordInvalid)

      expect do
        checklist.name = ""
        checklist.save!
      end.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
  describe "#recurrence" do
    it 'valid with recurrence if planned' do
      checklist.is_planned = true
      checklist.recurrence = 6.months
      assert checklist.valid?
    end

    it 'invalid without recurrence if planned' do
      checklist.is_planned = true
      checklist.recurrence = nil
      refute checklist.valid?
      assert_equal :recurrence,  checklist.errors.first.attribute
    end

    
    it 'valid without recurrence if unplanned' do
      checklist.is_planned = false
      checklist.recurrence = nil
      assert checklist.valid?
    end

    it 'invalid with recurrence if unplanned' do
      checklist.is_planned = false
      checklist.recurrence = 6.months
      refute checklist.valid?
      assert_equal :recurrence,  checklist.errors.first.attribute
    end
  end
end
