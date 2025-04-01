# frozen_string_literal: true

# The build environment is used during Docker image building
# It's designed to be minimal and avoid database connections

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Disable code reloading
  config.enable_reloading = false

  # Disable eager loading during build
  config.eager_load = false

  # Disable database connections during build
  config.active_record.database_selector = nil
  config.active_record.database_resolver = nil

  # Disable caching
  config.cache_store = :null_store

  # Disable logging
  config.logger = ActiveSupport::Logger.new(nil)
  config.log_level = :fatal

  # Disable asset serving
  config.public_file_server.enabled = false

  # Disable mailer
  config.action_mailer.perform_deliveries = false

  # Disable job processing
  config.active_job.queue_adapter = :null

  # Disable storage
  config.active_storage.service = :null
end
