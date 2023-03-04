# frozen_string_literal: true

require_relative 'client'
require_relative 'errors'

module Orchestrator
  module Adapter
    def self.get_items(params)
      permitted_params = [:kind, :sort_direction, :sort_by, :term, :with_meta, :id] 
      response = check_response(client.get('api/v1/items', params.slice(*permitted_params)))
      response = response.body.with_indifferent_access
      response[:items] = response[:items].map { |item| Item.new(item) }
      response
    end

    def self.create_order(params)
      permitted_params = [:customer_email, :address, :front_door, :floor, :intercom, :no_hand, :customer_id, :items]

      check_response(client.post('api/v1/orders', params.slice(*permitted_params)))
    end

    def self.client
      Client.instance.connection
    end

    def self.check_response(response)
      raise Errors::BadRequest.new if response.status == 400

      raise Errors::InternalServerError.new if response.status == 500

      response
    end

    private_class_method :check_response
    private_class_method :client
  end
end
