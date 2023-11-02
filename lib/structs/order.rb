# frozen_string_literal: true

module Structs
  class Order < SymbolizeStruct
    attribute :id, Types::Integer
    attribute :state, Types::String
    attribute :created_at, Types::JSON::DateTime
    attribute :assembler_id, Types::Integer.optional
    attribute :courier_id, Types::Integer.optional
    attribute :cost_cops, Types::Integer.optional
    attribute :items, Types::Array.optional

    def cost_rub
      items.sum(&:cost_rub)
    end
  end
end
