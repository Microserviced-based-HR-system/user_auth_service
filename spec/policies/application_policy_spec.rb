# spec/policies/application_policy_spec.rb

require 'rails_helper'

RSpec.describe ApplicationPolicy do
  let(:user) { double('User') }
  let(:record) { double('Record') }
  let(:policy) { described_class.new(user, record) }

  describe '#index?' do
    it 'returns false' do
      expect(policy.index?).to be false
    end
  end

  describe '#show?' do
    it 'returns false' do
      expect(policy.show?).to be false
    end
  end

  describe ApplicationPolicy::Scope do
    let(:user) { double('User') }
    let(:scope) { double('Scope') }
    let(:policy_scope) { described_class.new(user, scope) }

    describe '#resolve' do
      it 'raises NotImplementedError' do
        expect { policy_scope.resolve }.to raise_error(NotImplementedError)
      end
    end
  end
end
