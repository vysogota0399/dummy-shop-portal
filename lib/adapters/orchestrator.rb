# frozen_string_literal: true

module Adapters
  class Orchestrator
    def find_order(id)
      client.send_request('GET', "/api/v1/orders/#{id}") do |response|
        items = response.dig('data', 'items').map do |item|
          Structs::Item.new(item)
        end

        Structs::Order.new(response['data'].merge(items: items))
      end
    end

    def item_categories
      client.send_request('GET', "/api/v1/items/categories")['data']
    end

    def validate_order(order)
      client.send_request('POST', '/api/v1/orders/validate', body: { order: order })
    rescue Client::ClientError => e
      Sentry.capture_exception(e)
      { errors: JSON.parse(e.message) }
    rescue Client::ServerError => e
      Sentry.capture_exception(e)
      { errors: e.message }
    end

    def create_order(order)
      client.send_request('POST', '/api/v1/orders', body: { order: order }) do |response|
        { data: Structs::Order.new(response['data']) }
      end
    rescue Client::ClientError => e
      Sentry.capture_exception(e)
      { errors: JSON.parse(e.message) }
    rescue Client::ServerError => e
      Sentry.capture_exception(e)
      { errors: e.message }
    end

    def items_by_filter(filter)
      client.send_request('POST', '/api/v1/items/filter', body: filter) do |response|
        items = response['data'].map { |item| Structs::Item.new(item) }
        meta = response['meta']
        Structs::Frontend::Items.new(items: items, meta: meta)
      end
    end

    def orders_by_filter(filter)
      client.send_request('POST', '/api/v1/orders/filter', body: filter) do |response|
        orders = response['data'].map do |order|
          items = order['items'].map { |item| Structs::Item.new(item) }
          Structs::Order.new(order.merge(items: items))
        end
        meta = response['meta']
        Structs::Frontend::Orders.new(orders: orders, meta: meta)
      end
    end

    private

    def client
      @client ||= begin
        Client.new.configure do |config|
          config.base_url = Integration.find_by(code: 'orchestrator').host
          config.logger = _logger
        end
      end
    end

    def _logger
      SemanticLogger['OrchestratorHttpClient']
    end
  end
end
