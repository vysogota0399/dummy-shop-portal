# frozen_string_literal: true

module Structs
  module Frontend
    class Items < SymbolizeStruct
      attribute :items, Types::Array
      attribute :meta do
        attribute :count, Types::Integer
        attribute :page, Types::Integer
        attribute :items, Types::Integer
        attribute :item_kinds, Types::Array
        attribute :item_order_by, Types::Array
        attribute :item_order_direction, Types::Array
      end
    end
  end
end
