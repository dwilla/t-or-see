# frozen_string_literal: true

# Configure Redis for Action Cable
Rails.application.configure do
  config.action_cable.mount_path = nil
  config.action_cable.url = "wss://#{ENV['FLY_APP_NAME']}.fly.dev/cable"
  config.action_cable.allowed_request_origins = [
    "https://#{ENV['FLY_APP_NAME']}.fly.dev",
    "http://#{ENV['FLY_APP_NAME']}.fly.dev"
  ]
end

# Configure Redis connection
redis_url = ENV.fetch("REDIS_URL") { "redis://localhost:6379/1" }

# Configure Redis for Action Cable
Rails.application.config.action_cable.cable = {
  adapter: "redis",
  url: redis_url,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  channel_prefix: "#{Rails.application.config.action_cable.mount_path}_#{Rails.env}"
}

# Configure Redis for caching
Rails.application.config.cache_store = :redis_cache_store, {
  url: redis_url,
  ssl_params: { verify_mode: OpenSSL::SSL::VERIFY_NONE },
  error_handler: ->(method:, returning:, exception:) {
    Rails.logger.error "Redis error: #{exception.class} - #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
    Sentry.capture_exception(exception) if defined?(Sentry)
  }
}
