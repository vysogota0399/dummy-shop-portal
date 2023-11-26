# frozen_string_literal: true

class BunnyConnection
  extend Dry::Configurable
  
  class << self
    def configure
      yield(self)
    end

    def config=(value)
      @@config = value
    end

    def config
      @@config
    end

    def start
      @@connection = Bunny.new(config)
      @@connection.start
    end

    def connection
      @@connection
    end
  end
end
