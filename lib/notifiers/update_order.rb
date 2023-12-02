# frozen_string_literal: true

module Notifiers
  class UpdateOrder
    attr_reader :order

    JOIN = '_'

    def call(user_id:, order:, adapter:, orders_finder:)
      @order = order
      @user_id = user_id
      @stream_name = ['orders_index', user_id]
      @adapter = adapter
      @orders_finder = orders_finder
      return order_update unless order.delivered?

      remove_from_active_orders
      append_to_delivered_orders
    end

    private

    def order_update
      Turbo::StreamsChannel.broadcast_update_to(
        @stream_name,
        partial: 'orders/show',
        target: dom_id(order),
        locals: {
          order: order
        }
      )
    end
    
    def remove_from_active_orders
      add_zero_active_orders_filler
      Turbo::StreamsChannel.broadcast_remove_to(
        @stream_name,
        target: dom_id(order),
      )
    end

    def append_to_delivered_orders
      remove_zero_delivered_orders_filler
      Turbo::StreamsChannel.broadcast_append_to(
        @stream_name,
        partial: 'orders/show',
        target: 'finished_orders',
        locals: {
          order: order
        }
      )
    end

    # Удаляем заглушку "У вас еще нет завершенных заказов"
    def remove_zero_delivered_orders_filler
      return if customer_already_had_delivered_orders?

      Turbo::StreamsChannel.broadcast_remove_to(
        @stream_name,
        target: 'zero_delivered_orders_filler',
      )
    end

    # Добавляем заглушку "У вас еще нет активных заказов"
    def add_zero_active_orders_filler
      return if customer_has_active_orders?

      Turbo::StreamsChannel.broadcast_append_to(
        @stream_name,
        partial: 'orders/zero_active_orders_filler',
        target: 'current_orders',
      )
    end

    def dom_id(order)
      "#{order.model_name.param_key}#{JOIN}#{order.to_key.join(JOIN)}"
    end

    def customer_already_had_delivered_orders?
      orders.count(&:delivered?) > 1
    end

    def customer_has_active_orders?
      orders.reject(&:delivered?).any?
    end

    def orders
      @orders ||= begin
        @orders_finder.call(
          orchestrator_adapter: @adapter,
          customer_id: @user_id,
        ).orders
      end
    end
  end
end
