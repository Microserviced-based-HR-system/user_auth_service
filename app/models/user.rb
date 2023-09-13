class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
  :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  validates :username, presence: true, length: { minimum: 3 }
  validates :email, presence: true
  validates :password, presence: true, format: { with: /\A(?=.*[a-zA-Z])(?=.*[0-9]).{6,}\z/,
    message: "must be at least 6 characters long and include both letters and numbers" }, if: :password_required?
  private

  def assign_default_role
    self.add_role(:user) 
  end

  def password_required?
    new_record? || password.present?
  end
  
end
