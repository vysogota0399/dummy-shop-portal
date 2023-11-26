Rails.application.config.after_initialize do |app|
  BunnyConnection.configure do |bunny|
    bunny.config = app.config.bunny
  end

  BunnyConnection.start
end