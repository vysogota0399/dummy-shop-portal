# frozen_string_literal: true

require_relative 'client'

module Orchestrator
  module Adapter
    def self.get_items(params)
      permitted_params = [:kind, :sort_direction, :sort_by, :term, :with_meta, :id] 
      response = client.get('api/v1/items', params.slice(*permitted_params))
                       .body
                       .with_indifferent_access
                       
      response[:items] = response[:items].map { |item| Item.new(item) }
      response
    end

    def self.client
      Client.instance.connection
    end
  end
end
