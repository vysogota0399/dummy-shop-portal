# frozen_string_literal: true

class ItemFinder
  attr_reader :params

  def self.call(params)
    new(params).call
  end

  def initialize(params)
    @orchestrator_adapter = params.delete(:orchestrator_adapter)
    @params = params
    @initial_scope = {}
  end

  def call
    @initial_scope
      .then { |scope| prepare_filters(scope) }
      .then { |scope| prepare_order(scope) }
      .then { |scope| @orchestrator_adapter.items_by_filter(scope) }
  end

  private

  def prepare_filters(scope)
    scope[:filter] = params.slice(:kind) if params.key?(:kind)
    scope[:id] = params[:id] if params.key?(:id)
    scope
  end

  def prepare_order(scope)
    return scope unless params.key?(:order_by) && params.key?(:order_direction)
    
    scope[:order] = { params[:order_by] => params[:order_direction] }
    scope
  end
end
