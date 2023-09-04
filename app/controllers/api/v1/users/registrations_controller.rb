# frozen_string_literal: true

class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  include RackSessionsFix
  respond_to :json
  
  private

  def respond_with(current_user, _opts = {})
    if resource.persisted?
      render json: {
        code: 200, message: 'Signed up successfully.',
        data: UserSerializer.new(current_user).serializable_hash[:data][:attributes]
      }
    else
      render json: {
        message: "User couldn't be created successfully. #{current_user.errors.full_messages.to_sentence}"
      }, status: :unprocessable_entity
    end
  end

end
