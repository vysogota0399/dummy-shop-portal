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
    setting :logger, reader: false, default: SemanticLogger['HttpClient']

    def send_request(method, uri, args = {})
      response = nil
      logged(method, uri, args) do
        case method
        when 'POST'
          payload = args[:body].to_json
          response, message = process_message(client.request(method, uri, body: payload))
        when 'GET'
          response, message = process_message(client.request(method, uri, query: args[:query]))
        when 'DELETE'
          payload = args[:body].to_json
          response, message = process_message(client.request(method, uri, body: payload))
        end
        # message contains info for logger
        message
      end

      return response unless block_given?

      yield response
    end

    private

    def client
      @client ||= begin
        client =
          JSONClient.new(
            base_url: config.base_url,
            default_header: {
              'HTTP_X-Request-Id' => Thread.current[:request_id]
            }
          )
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
        [content.slice('data', 'meta'), message]
      when 400 .. 499
        raise ClientError.new(content.slice('errors').merge(status: message.status).to_json)
      when 500 .. 599
        raise ServerError.new(content.slice('errors').merge(status: message.status).to_json)
      end
    end

    def logger
      config.logger
    end

    def logged(method, uri, args)
      log_payload = {
        request: {
          method: method,
          uri: uri,
        }
      }
      log_payload[:request][:body] = args[:body] if args.key?(:body)
      log_payload[:request][:query] = args[:query] if args.key?(:query)
      message = yield
      log_payload[:response] = {
        status: message.status,
        data: message.content,
      }
      logger.debug(payload: log_payload)
    rescue ClientError, ServerError => e
      response = JSON.parse(e.message)
      error = {
        status: response['status'],
        errors: response['errors']
      }
      logger.error(log_payload.merge(error))
      raise e
    end
  end
end
