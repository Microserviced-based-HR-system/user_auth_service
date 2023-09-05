class User < ApplicationRecord
  rolify
  after_create :assign_default_role
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable, :recoverable, 
  :validatable, :jwt_authenticatable, jwt_revocation_strategy: self

  private

  def assign_default_role
    self.add_role(:user) 
  end
  
end
