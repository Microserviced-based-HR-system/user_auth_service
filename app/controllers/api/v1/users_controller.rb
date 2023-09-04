class Api::V1::UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
    serialized_users = @users.map do |user|
      UserSerializer.new(user).serializable_hash[:data][:attributes]
    end

    render json: {
      code: 200, message: 'User List',
      data: serialized_users
    }, status: :ok

  end

  def show
    @user = User.find(params[:id])
    
    render json: {
      code: 200, message: 'Get User by Id',
      data: UserSerializer.new(@user).serializable_hash[:data][:attributes]
    }, status: :ok
  end

end
