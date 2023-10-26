# frozen_string_literal: true

module Structs
  class SymbolizeStruct < Dry::Struct
    transform_keys(&:to_sym)
  end
end
