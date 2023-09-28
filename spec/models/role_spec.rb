require "rails_helper"

RSpec.describe Role, type: :model do
  let(:role) { FactoryBot.create(:role) }
  let(:user) { FactoryBot.create(:user) }

  describe "check associations" do
    it { should have_and_belong_to_many(:users).join_table(:users_roles) }
    it { should belong_to(:resource).optional(true) }
  end

  context "has_and_belongs_to_many" do
    it "has_and_belongs_to_many users" do
      role.users << user
      expect(role.users).to include(user)
    end
  end

  context "validations" do
    it { should validate_inclusion_of(:resource_type).in_array(Rolify.resource_types).allow_nil }
  end

  context "scopes" do
    it "responds to scopify" do
      expect(Role).to respond_to(:scopify)
    end
  end
end
