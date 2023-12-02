# frozen_string_literal: true

class OrdersFinder
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
      .then { |scope| @orchestrator_adapter.orders_by_filter(scope) }
  end

  private

  def prepare_filters(scope)
    return scope unless params.key?(:filter)

    scope[:filter] = { 
      state: state_mapper(params[:filter][:state]),
      customer_id: params[:customer_id]
    }

    scope
  end

  def prepare_order(scope)
    scope[:order] = { created_at: :desc }
    scope
  end

  def state_mapper(state)
    {
      'active' => %w[not_delivered not_damaged],
      'finished' => %w[delivered damaged],
    }[state]
  end
end
