require_relative "boot"

require "rails/all"
require_relative '../lib/middlewares/set_request_id_middleware'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Vds
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Elk stask integration for logging
    config.autoload_lib(ignore: %w(assets tasks))
    config.i18n.default_locale = :ru
    config.log_tags = {
      request_id: :request_id,
    }
    config.bunny = config_for(:bunny)
    config.middleware.use Middlewares::SetRequestIdMiddleware
    config.action_cable.mount_path = nil
    config.action_cable.url = ENV.fetch('WS_SERVER_URL') { 'ws://127.0.0.1:28080' }
    config.action_cable.disable_request_forgery_protection = true
  end
end
