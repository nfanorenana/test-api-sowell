require 'rails_helper'
RSpec.describe Role, :type => :model do
  let(:company) { create(:company) }
  let(:user) { create(:user, company: company) }
  let(:sector) { create(:sector, company: company) }
  let(:role) { create(:role, user: user, sector: sector) }
  describe '#name' do
    it 'is not empty' do
      expect  {
        role.name = nil
        role.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect  {
        role.name = ""
        role.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is included in roles list' do
      expect {
        role.name = :unknown
        role.save!
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect {
        role.name = 999
        role.save!
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'superadmin' do
    let(:other_user) { create(:user, company: nil) }
    it 'is added on users not belonging to a company and sector' do
      other_user.add_role!(:superadmin)
      expect(other_user).to be_valid
    end

    it 'is not added on users belonging to a company' do
      expect { user.add_role!(:superadmin) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not added twice on same user' do
      expect {
        user.add_role!(:superadmin)
        user.add_role!(:superadmin) 
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not added with a sector' do
      expect { user.add_role!(:superadmin, sector) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'admin' do
    it 'is added on users belonging to a company' do
      user_admin = create(:user, company: company)
      user_admin.add_role!(:admin)
      expect(user_admin).to be_valid
    end

    it 'is not added on users not belonging to a company' do
      @user = create(:user)
      expect { @user.add_role!(:admin) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not added twice on same user' do
      expect {
        user.add_role!(:admin)
        user.add_role!(:admin) 
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'is not added with a sector' do
      expect { user.add_role!(:admin, sector) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'manager, reporter and checklister' do
    it 'are added once to same user on same sector' do
      user_more_roles = create(:user, company: company)
      user_more_roles.add_role!(:manager, sector)
      expect(user_more_roles).to be_valid

      user_more_roles.add_role!(:reporter, sector)
      expect(user_more_roles).to be_valid

      user_more_roles.add_role!(:checklister, sector)
      expect(user_more_roles).to be_valid
    end

    it 'are not added twice to same user on same sector' do
      expect {
        user.add_role!(:manager, sector)
        user.add_role!(:manager, sector)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect {
        user.add_role!(:reporter, sector)
        user.add_role!(:reporter, sector)
      }.to raise_error(ActiveRecord::RecordInvalid)

      expect {
        user.add_role!(:checklister, sector)
        user.add_role!(:checklister, sector)
      }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'are not added without sector' do
      expect { user.add_role!(:manager) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { user.add_role!(:reporter) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { user.add_role!(:checklister) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'are not added to users not belonging to a company' do
      @user = create(:user)
      expect { @user.add_role!(:manager, sector) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { @user.add_role!(:reporter, sector) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { @user.add_role!(:checklister, sector) }.to raise_error(ActiveRecord::RecordInvalid)
    end

    it 'are not added on sector belonging to another company' do
      @sector = create(:sector, company: create(:company, name: 'another_company'), name: 'man_sector_one')
      expect { user.add_role!(:manager, @sector) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { user.add_role!(:reporter, @sector) }.to raise_error(ActiveRecord::RecordInvalid)
      expect { user.add_role!(:checklister, @sector) }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end