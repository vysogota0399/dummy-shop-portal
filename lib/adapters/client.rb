# frozen_string_literal: true
require 'jsonclient'

module Adapters
  class Client
    include Dry::Configurable

    class HTTPError < StandardError; end
    class ClientError < HTTPError; end
    class ServerError < HTTPError; end
    class NotFoundError < ClientError; end

    setting :connect_timeout, reader: false, default: 1
    setting :receive_timeout, reader: false, default: 1
    setting :send_timeout, reader: false, default: 1
    setting :token, reader: false
    setting :ssl, reader: false, default: false
    setting :base_url, reader: false, constructor: proc { |host| "http://#{host}" }
    setting :logger, reader: false, default: ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)).tagged(Thread.current[:request_id], "HTTP_Client")

    def send_request(method, uri, args = {})
      logger.info { "Request #{method} #{uri}" }
      response = nil
      case method
      when 'POST'
        payload = args[:body].to_json
        logger.debug { "Payload #{payload}" }
        response = process_message(client.request(method, uri, body: payload))
      when 'GET'
        logger.debug { "Query #{args[:query]}" }
        response = process_message(client.request(method, uri, query: args[:query]))
      when 'DELETE'
        payload = args[:body].to_json
        logger.debug { "Payload #{payload}" }
        response = process_message(client.request(method, uri, body: payload))
      end

      return response unless block_given?

      yield response
    end

    private

    def client
      @client ||= begin
        client = JSONClient.new(base_url: config.base_url)
        client.connect_timeout = config.connect_timeout
        client.receive_timeout = config.receive_timeout
        client.send_timeout = config.send_timeout
        client
      end
    end

    def process_message(message)
      content = message.content
      case message.status
      when 200 .. 299
        logger.info { "Response #{message.status}" }
        logger.debug { content }
        content.slice('data', 'meta')
      when 400 .. 499
        logger.error { "Response #{message.status}" }
        logger.debug { content }
        raise ClientError.new(content['error'])
      when 500 .. 599
        logger.error { "Response #{message.status}" }
        logger.debug { content }
        raise ServerError.new(content['error'])
      end
    end

    def logger
      config.logger
    end
  end
end
