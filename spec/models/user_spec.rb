require 'rails_helper'
RSpec.describe User, :type => :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  describe "#default user" do
    it "is valid" do
      expect(user).to be_valid
    end
  end

  describe "#new" do
    it "has expected default values" do
      expect(user.email_notifications_activated?).to eq(true)
      expect(user.can_close_issue_reports?).to eq(false)
      expect(user.status).to eq('active')
      expect(user.notifications).to eq([])
      expect(user.recipients).to eq([])
      expect(user.hardware).to eq({})
      expect(user.superadmin?).to eq(false)
    end
  end

  describe '#email' do
    it 'is changeable' do
      user.email = 'correct@email.com'
      assert user.save!
    end

    it 'is not empty' do
      expect  {
        user.email = nil
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect  {
        user.email = ""
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is unique' do
      expect { 
        create(:user, email: "unique email")
        create(:user, email: "unique email") 
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is valid email' do
      expect {
        user.email = 'just_text'
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is transformed to lowercase' do
      user.email = 'UPPER@CASE.EMAIL'
      expect(user.email).to eq('upper@case.email')
    end
  end

  describe '#password' do
    it 'is changeable' do
      user.password = 'correct@email.com'
      assert user.save!
    end

    it 'is not empty' do
      expect  {
        user.password = nil
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect  {
        user.password = ""
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not less than 6 characters' do
      expect  {
        user.password = "12345"
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#company' do
    it 'is settable for new users' do
      user.company = company
      assert user.save!
    end

    it 'is not settable for superadmins' do
      expect {
        user.add_role! :superadmin
        user.company = company
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not changeable for existing users' do
      expect {
        @user = create(:user, company: company, email: "another@email.com")
        @user.company = create(:company, name: 'Another company')
        @user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect {
        user.company = nil
        user.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end