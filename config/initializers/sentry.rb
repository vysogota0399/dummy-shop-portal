Sentry.init do |config|
  config.dsn = Rails.application.credentials.sentry.sdk

  # To activate performance monitoring, set one of these options.
  # We recommend adjusting the value in production:
  config.traces_sample_rate = 1.0
  config.profiles_sample_rate = 1.0
  config.logger = SemanticLogger['Sentry']

  # or
  config.traces_sampler = lambda do |context|
    true
  end

  # hint is a dict {:exception => ex | nil, :message => message | nil}
  config.before_send = lambda do |event, hint|
    Rails.application.config.logger.error(hint[:ex].backtrace, hint[:message])
    event
  end

  config.context_lines = 5
end