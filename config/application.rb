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
    config.logstash = config_for(:logstash)
    config.autoload_lib(ignore: %w(assets tasks middlewared))
    config.i18n.default_locale = :ru
    config.log_tags = {
      request_id: :request_id,
    }


    config.middleware.use SetRequestIdMiddleware
  end
end
