# frozen_string_literal: true
require 'faraday'

module Orchestrator
  class Client
    include Singleton

    attr_reader :connection

    def initialize
      @connection = faraday_connection
    end

    private

    def faraday_connection
      Faraday.new(orchestrator_url) do |f|
        f.response :logger, Logger.new('log/orchestrator_client.log'), { headers: true, bodies: { request: true, response: false }, errors: true }
        f.request :json
        f.response :json
      end
    end

    def orchestrator_url
      "http://#{ENV['ORCHESTRATOR_HOST']}:#{ENV['ORCHESTRATOR_PORT']}"
    end
  end
end
