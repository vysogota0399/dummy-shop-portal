# frozen_string_literal: true

module Consumers
  module Hendlers
    class UpdateOrder
      class << self
        def call(payload)
          new(
            payload: JSON.parse(payload),
            falsh_notifier: Notifiers::Flash.new,
            update_order_notifier: Notifiers::UpdateOrder.new 
          ).call
        end
      end

      attr_reader :payload, :falsh_notifier, :update_order_notifier

      def initialize(payload:, falsh_notifier:, update_order_notifier:)
        @payload = payload
        @falsh_notifier = falsh_notifier
        @update_order_notifier = update_order_notifier
      end

      def call
        items = payload.dig('data', 'items').map do |item|
          Structs::Item.new(item)
        end
        order = Structs::Order.new(payload['data'].merge(items: items))
        falsh_notifier.call(
          user_id: order.client.customer_id,
          message: 'order.order_state_updated'
        )

        update_order_notifier.call(
          user_id: order.client.customer_id,
          order: order,
          adapter: Adapters::Orchestrator.new,
          orders_finder: OrdersFinder,
        )
      end
    end
  end
end
