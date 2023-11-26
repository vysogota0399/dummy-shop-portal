# frozen_string_literal: true

module Consumers
  class UpdateOrder
    include Dry::Configurable

    setting :queue, reader: false, default: 'order_update'
    setting :routing_key, reader: false, default: 'order.update.portal'
    setting :exchange_name, reader: false, default: 'order_update'
    setting :logger, reader: false, default: SemanticLogger['UpdateOrderConsumer']

    class << self
      def start
        new.start
      end
    end

    def initialize

    end
  
    def start
      logger.debug("#{self.class} start")
      ch = BunnyConnection.connection.channel
      exchange = ch.topic(config.exchange_name, :auto_delete => false)
      queue = ch.queue(config.queue, auto_delete: false, :durable => true).bind(exchange, routing_key: config.routing_key)
      queue.subscribe(consumer_tag: self.class.to_s.underscore) do |delivery_info, properties, payload|
        logger.debug(
          data: {
            delivery_info: delivery_info,
            properties: properties,
            payload: payload,
          }
        )
      end

      loop { sleep 5 }
    end

    private

    attr_reader :connection

    def logger
      config.logger
    end
  end
end
