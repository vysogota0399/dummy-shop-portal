# frozen_string_literal: true

module Structs
  class Item < SymbolizeStruct
    attribute :id, Types::Integer
    attribute :kind, Types::String
    attribute :cost_cops, Types::Integer
    attribute :weight, Types::Integer
    attribute :remainder, Types::Integer
    attribute :title, Types::String
    attribute :description, Types::String
  
    def cost_rub
      (cost_cops.to_f / 100).ceil
    end
  end
end
