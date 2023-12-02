# frozen_string_literal: true

module Structs
  class SymbolizeStruct < Dry::Struct
    transform_keys(&:to_sym)
    extend ActiveModel::Naming

    def to_key
      Array.wrap(id)
    end
  end
end
