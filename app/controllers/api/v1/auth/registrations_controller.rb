# frozen_string_literal: true

class Api::V1::Auth::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  include RackSessionsFix
  respond_to :json

  def create
    user = User.new(sign_up_params)
    user.add_role(params[:role]) if params[:role]

    if user.save
      render json: {
               code: 200,
               message: "Signed up successfully.",
               data: UserSerializer.new(user).serializable_hash[:data][:attributes],
             }
    else
      render json: {
        message: "User couldn't be created successfully. #{user.errors.full_messages.to_sentence}",
      }, status: :unprocessable_entity
    end
  end
end
