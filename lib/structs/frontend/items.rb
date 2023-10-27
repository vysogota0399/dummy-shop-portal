# frozen_string_literal: true

module Structs
  module Frontend
    class Items < SymbolizeStruct
      attribute :items, Types::Array
      attribute :meta do
        attribute :count, Types::Integer
        attribute :page, Types::Integer
        attribute :items, Types::Integer
      end
    end
  end
end
