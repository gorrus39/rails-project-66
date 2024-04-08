# frozen_string_literal: true

Sentry.init do |config|
  config.enabled_environments = %w[production]

  config.dsn = 'https://4a2cd7be0ff56e5f5b9bcbb3fcb754d0@o4506834751651840.ingest.us.sentry.io/4507108098768896'
  config.breadcrumbs_logger = %i[active_support_logger http_logger]

  # Set traces_sample_rate to 1.0 to capture 100%
  # of transactions for performance monitoring.
  # We recommend adjusting this value in production.
  config.traces_sample_rate = 1.0
  # or
  config.traces_sampler = lambda do |_context|
    true
  end
  # Set profiles_sample_rate to profile 100%
  # of sampled transactions.
  # We recommend adjusting this value in production.
  config.profiles_sample_rate = 1.0
end

# example for testing errors.
# Sentry.capture_message('test message')
