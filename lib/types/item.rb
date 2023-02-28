# frozen_string_literal: true
require 'dry-types'
require 'dry-struct'


class Item < Dry::Struct
  transform_keys(&:to_sym)

  attribute :id, Dry.Types()::Integer
  attribute :kind, Dry.Types()::String
  attribute :cost_cops, Dry.Types()::Integer
  attribute :weight, Dry.Types()::Integer
  attribute :remainder, Dry.Types()::Integer
  attribute :title, Dry.Types()::String
  attribute :description, Dry.Types()::String
  attribute :created_at, Dry.Types()::String
  attribute :updated_at, Dry.Types()::String

  def cost_rub
    cost_cops.to_f/100.round(2)
  end
end

