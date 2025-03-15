class AuthenticationController < ApplicationController
  # Include Devise helpers
  include Devise::Controllers::Helpers

  def index
    # Alert for guest users wanting notifications
    if params[:notification_alert]
      flash.now[:alert] = "Please sign up or log in to receive event notifications!"
    end

    # resource for Devise forms
    @resource = User.new
    @resource_name = :user
  end

  def check_email
    @email = params[:email]

    # Validate email presence
    if @email.blank?
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to auth_path, alert: "Please provide an email address." }
      end
      return
    end

    # The logic for user existence is now in the turbo_stream template
    respond_to do |format|
      format.turbo_stream

      # Fallback for HTML format
      format.html do
        user_exists = User.exists?(email: @email)
        if user_exists
          redirect_to new_user_session_path(email: @email)
        else
          redirect_to new_user_registration_path(email: @email)
        end
      end
    end
  rescue => e
    Rails.logger.error "Error in check_email: #{e.message}"
    respond_to do |format|
      format.html { redirect_to auth_path, alert: "An error occurred. Please try again." }
      format.turbo_stream
      format.json { render json: { error: e.message }, status: :unprocessable_entity }
    end
  end
end
