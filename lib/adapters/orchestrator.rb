# frozen_string_literal: true

module Adapters
  class Orchestrator
    def items_by_filter(filter)
      client.send_request('POST', '/api/v1/items/filter', body: filter) do |response|
        items = response['data'].map { |item| Structs::Item.new(item) }
        meta = response['meta']
        Structs::Frontend::Items.new(items: items, meta: meta)
      end
    end

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
      ActiveSupport::TaggedLogging.new(Logger.new(STDOUT)).tagged(Thread.current[:request_id], "OrchestratorAdapter")
    end
  end
end
