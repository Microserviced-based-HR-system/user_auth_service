class User < ApplicationRecord
  rolify
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise(
    :database_authenticatable,
    :registerable,
    :recoverable,
    :validatable,
    :jwt_authenticatable,
    jwt_revocation_strategy: self,
  )

  validates :username, presence: true, length: { minimum: 3 }
  validates :email, presence: true
  validates :password, presence: true, format: {
                         with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/,
                         message: "must be at least 6 characters long and include both letters and numbers",
                       }, if: :password_required?

  ROLES = %w[user administrator hr_manager employee candidate]

  def add_role(role_name, resource = nil)
    if ROLES.include?(role_name)
      super
    else
      errors.add(:roles, "Invalid role: #{role_name}")
      false
    end
  end

  after_create :assign_default_role

  private

  def assign_default_role
    add_role(User::ROLES.first)
  end

  def password_required?
    new_record? || password.present?
  end
end
