Rails.application.config.after_initialize do |app|
  $stdout.sync = true
  app.config.logger = SemanticLogger['Portal']
  if ENV.fetch('RAILS_LOG_TO_STDOUT', true)
    app.config.semantic_logger.add_appender(io: $stdout, level: app.config.logger.level, formatter: :color)
  end

  if ENV.fetch('RAILS_LOG_TO_KIBANA', false)
    app.config.semantic_logger.add_appender(
      appender:    :elasticsearch,
      url:         "http://elastic:changeme@elasticsearch:9200",
      index:       'portal-logs',
      data_stream: true
    )
  end

  Rails.application.config.active_record.logger = SemanticLogger['ActiveRecord']
  Rails.application.config.action_mailer.logger = SemanticLogger['ActionMailer']
end
