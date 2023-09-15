require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:user) { FactoryBot.create(:user) }

  subject { described_class }

  permissions :assign_role?, :remove_role? do
    it "grants access to hr_manager" do
      user.add_role("hr_manager")
      expect(subject).to permit(user)
    end

    it "denies access to non-hr_manager users" do
      expect(subject).not_to permit(user)
    end
  end
end
