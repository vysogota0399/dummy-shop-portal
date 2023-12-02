# frozen_string_literal: true

module Structs
  class Order < SymbolizeStruct
    STATES = {
      canceled: -1,
      damaged: 0,
      waiting_for_payment: 1,
      waiting_for_the_assembly: 2,
      assembling: 3,
      waiting_for_the_courier: 4,
      delivering: 5,
      delivered: 6,
    }.with_indifferent_access

    attribute :id, Types::Integer
    attribute :state, Types::String
    attribute :created_at, Types::JSON::DateTime
    attribute :assembler_id, Types::Integer.optional
    attribute :courier_id, Types::Integer.optional
    attribute :cost_cops, Types::Integer.optional
    attribute :items, Types::Array.optional

    attribute :client do
      attribute :customer_id, Types::Integer
      attribute :customer_email, Types::String
      attribute :front_door, Types::String
      attribute :floor, Types::String
      attribute :intercom, Types::String
    end

    def cost_rub
      items.sum(&:cost_rub)
    end

    def delivered?
      state == 'delivered'
    end
  end
end
