# frozen_string_literal: true

class Api::V1::Auth::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]
  before_action :sign_out_if_signed_in, only: [:create]
  respond_to :json

  def create
    user_signed_in? ? render_logged_in_response : render_unauthorized_response
  end

  private

  def render_logged_in_response
    render json: {
      code: 200,
      message: "Logged in successfully.",
      data: { user: UserSerializer.new(current_user).serializable_hash[:data][:attributes] },
    }, status: :ok
  end

  def render_unauthorized_response
    render json: {
      error: "Invalid Email or password.",
    }, status: :unauthorized
  end

  def respond_to_on_destroy
    response_data = {}

    if request.headers["Authorization"].present?
      begin
        jwt_payload = JWT.decode(request.headers["Authorization"].split.last, ENV.fetch("DEVISE_JWT_SECRET_KEY")).first
      rescue JWT::DecodeError => e
        response_data = {
          status: 401,
          message: e.message,
        }
      end
    end

    if current_user.nil?
      response_data = {
        status: 200,
        message: "Logged out successfully.",
      }
    else
      response_data = {
        status: 401,
        message: "Couldn't find an active session.",
      }
    end

    render json: response_data, status: response_data[:status]
  end

  def sign_out_if_signed_in
    sign_out(current_user) if user_signed_in?
  end
end
