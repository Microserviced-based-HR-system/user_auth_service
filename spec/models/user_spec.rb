require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.build(:user)}

  context "with valid attributes" do
    it 'is valid' do
      expect(user).to be_valid
    end
  end

  context 'with invalid attributes' do
    it 'is invalid when username is blank' do
      user.username = ''
      expect(user).to_not be_valid
    end

    it 'is invalid when username is too short' do
      user.username = 'us'
      expect(user).to_not be_valid
    end

    it 'is invalid when email is blank' do
      user.email = ''
      expect(user).to_not be_valid
    end

    it 'is invalid when password is invalid' do
      user.password = 'Pw1'
      expect(user).to_not be_valid
    end
  end
  
  context 'with a valid password' do
    it 'is valid' do
      user.password = 'Password1'
      expect(user).to be_valid
    end
  end

  context 'with an invalid password' do
    it 'is invalid when password is blank' do
      user.password = ''
      expect(user).to_not be_valid
    end

    it 'is invalid when password is too short' do
      user.password = 'Pw1'
      expect(user).to_not be_valid
    end

    it 'is invalid when password lacks letters' do
      user.password = '123456'
      expect(user).to_not be_valid
    end

    it 'is invalid when password lacks numbers' do
      user.password = 'Password'
      expect(user).to_not be_valid
    end
  end

  context 'has a default role' do
    it 'assign the default role' do
      user = FactoryBot.create(:user)
      expect(user.has_role?(:user)).to be true
    end
  end

  describe '#add_role' do
    let(:user) { FactoryBot.create(:user) }

    context 'when a valid role is added' do
      it 'adds the role to the user' do
        expect(user.add_role('employee')).to be_truthy
        expect(user.has_role?('employee')).to be_truthy
      end
    end

    context 'when an invalid role is added' do
      it 'returns false and adds an error message' do
        expect(user.add_role('invalid_role')).to be_falsey
        expect(user.has_role?('invalid_role')).to be_falsey
        expect(user.errors[:roles]).to include('Invalid role: invalid_role')
      end
    end
  end

end
