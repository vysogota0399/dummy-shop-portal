# frozen_string_literal: true

module Structs
  module Frontend
    class Orders < SymbolizeStruct
      attribute :orders, Types::Array
      attribute :meta do
        attribute :count, Types::Integer
        attribute :page, Types::Integer
        attribute :items, Types::Integer
      end
    end
  end
end
