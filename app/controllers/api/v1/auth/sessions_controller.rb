# frozen_string_literal: true

class Api::V1::Auth::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  respond_to :json

  private
  def respond_with(current_user, _opts = {})
    if user_signed_in?
      render json: {
        code: 200,
        message: 'Logged in successfully.',
        data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] }
      }, status: :ok
    else
      render json: {
        error: 'Invalid Email or password.'
      }, status: :unauthorized
    end
  end

  def respond_to_on_destroy
    response_data = {}
    
    if request.headers['Authorization'].present?
      begin
        jwt_payload = JWT.decode(request.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key!).first
      rescue JWT::DecodeError => e
        response_data = {
          status: 401,
          message: e.message
        }
      end
    end
    
    if current_user
      response_data = {
        status: 200,
        message: 'Logged out successfully.'
      }
    else
      response_data = {
        status: 401,
        message: "Couldn't find an active session."
      }
    end
  
    render json: response_data, status: response_data[:status]
  end
  
  
end
