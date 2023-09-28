class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!
  include Pagy::Backend

  def index
    @pagy, @users = pagy(User.order(created_at: :desc), items: params[:per_page])
    render_success("User List", serialized_users, pagy_metadata(@pagy))
  end

  def show
    begin
      @user = find_user
      render_success("User Details", serialized_user(@user))
    rescue ActiveRecord::RecordNotFound
      render_error("User not found", :not_found)
    end
  end

  def assign_role
    authorize_and_perform_action("add")
  end

  def remove_role
    authorize_and_perform_action("remove")
  end

  def update_username
    new_username = params[:username]
    if current_user&.update(username: new_username)
      render_success("Username updated to '#{new_username}'.", serialized_user(current_user))
    else
      render_error("Username update failed.")
    end
  end

  private

  def authorize_and_perform_action(action)
    authorize current_user
    user = find_user
    role_name = params[:role]

    if user&.send("#{action}_role", role_name)
      render_success("Role '#{role_name}' #{action}ed.", serialized_user(user))
    else
      render_error("Invalid role name, failed.")
    end
  end

  def render_success(message, data, pagy = nil)
    response_data = {
      code: 200,
      message: message,
      data: data,
    }
    response_data[:pagy] = pagy if pagy
    render json: response_data
  end

  def render_error(error_message, status = :unprocessable_entity)
    render json: { error: error_message }, status: status
  end

  def find_user
    User.find(user_params[:id])
  end

  def serialized_user(user)
    UserSerializer.new(user).serializable_hash[:data][:attributes]
  end

  def serialized_users
    @users.map { |user| serialized_user(user) }
  end

  def user_params
    params.permit(:id, :username)
  end
end
