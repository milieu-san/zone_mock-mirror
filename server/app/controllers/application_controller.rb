# frozen_string_literal: true

class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  # skip_before_action :verify_authenticity_token, if: :devise_controller? # APIではCSRFチェックをしない
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end

  # redefined devise methods
  def current_user
    current_api_v1_user
  end

  def authenticate_user!
    authenticate_api_v1_user!
  end
end
