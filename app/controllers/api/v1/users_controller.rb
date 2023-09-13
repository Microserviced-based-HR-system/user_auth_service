class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  def index
    @pagy, @users = pagy(User.order(created_at: :desc), items: params[:per_page])
    render_success("User List", users: @users, pagy: pagy_metadata(@pagy))
  end

  def show
    @user = User.find(params[:id])
    render_success("User Details", @user)
  end

  def assign_role
    unless current_user.has_role?("hr_manager")
      return render_error("Role assignment failed.")
    end

    user = User.find(params[:id])
    role_name = params[:role]

    if user && user.add_role(role_name)
      render_success("Role '#{role_name}' assigned to user '#{user.username}'.", user)
    else
      render_error("Role assignment failed.")
    end
  end

  def remove_role
    unless current_user.has_role?("hr_manager")
      return render_error("Role removal failed.")
    end

    user = User.find(params[:id])
    role_name = params[:role]

    if user && user.remove_role(role_name)
      render_success("Role '#{role_name}' removed from user '#{user.username}'.", user)
    else
      render_error("Role removal failed.")
    end
  end

  def update_username
    user = User.find(params[:id])
    new_username = params[:username]

    if user && user.update(username: new_username)
      render_success("Username updated to '#{new_username}'.", user)
    else
      render_error("Username update failed.")
    end
  end

  private

  def render_success(message, data)
    response_data = {
      code: 200,
      message: message
    }

    if data.is_a?(User)
      response_data[:user] = UserSerializer.new(data).serializable_hash[:data][:attributes]
    else
     
      response_data[:users] = data[:users].map do |user|
        UserSerializer.new(user).serializable_hash[:data][:attributes]
      end
      response_data[:pagy] = data[:pagy]
    end

    render json: response_data
  end

  def render_error(error_message, status = :unprocessable_entity)
    render json: { error: error_message }, status: status
  end
end
