Rails.application.config.after_initialize do |app|
  $stdout.sync = true
  app.config.logger = SemanticLogger['Portal']
  if ENV.fetch('RAILS_LOG_TO_STDOUT', true)
    app.config.semantic_logger.add_appender(io: $stdout, level: app.config.logger.level, formatter: :json)
  end

  if ENV.fetch('RAILS_LOG_TO_KIBANA', false)
    log_stash = LogStashLogger.new(app.config.logstash)
    app.config.semantic_logger.add_appender(logger: log_stash, formatter: :json)
  end

  Rails.application.config.active_record.logger = SemanticLogger['ActiveRecord']
  Rails.application.config.action_mailer.logger = SemanticLogger['ActionMailer']
end
