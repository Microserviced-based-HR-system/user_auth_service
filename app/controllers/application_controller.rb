class ApplicationController < ActionController::API
  include Pundit::Authorization

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[username role])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[username role])
  end

  def user_not_authorized
    render json: { error: "You are not authorized to perform this action.", status: 401 }, status: 401
  end
end
