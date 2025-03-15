# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    # Handles the email check for custom sign in/up forms
    if params[:email].present?
      self.resource = resource_class.new(email: params[:email])
    end
    super
  end

  # POST /resource/sign_in
  def create
    super
  end

  # DELETE /resource/sign_out
  def destroy
    super
  end

  protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end

  # Redirect to the unified auth page instead of the login page
  def after_sign_out_path_for(resource_or_scope)
    auth_path
  end
end
