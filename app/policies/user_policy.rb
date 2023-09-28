class UserPolicy < ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    raise Pundit::NotAuthorizedError, "You are not authorized to perform this action." unless user

    @user = user
    @record = record
  end

  def assign_role?
    @user.has_any_role?("hr_manager", "administrator")
  end

  def remove_role?
    @user.has_any_role?("hr_manager", "administrator")
  end
end
