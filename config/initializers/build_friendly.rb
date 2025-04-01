# frozen_string_literal: true

# This initializer helps handle environment variables during the Docker build process
# by providing default values when environment variables are not available

module BuildFriendly
  def self.env_or_default(key, default)
    ENV[key].presence || default
  end
end

# Only run these configurations if we're not in a build environment
unless ENV["RAILS_ENV"] == "build"
  # Add any environment-dependent configurations here
  # For example:
  # Rails.application.config.action_mailer.default_url_options = {
  #   host: BuildFriendly.env_or_default('HOST', 'localhost:3000')
  # }
end
