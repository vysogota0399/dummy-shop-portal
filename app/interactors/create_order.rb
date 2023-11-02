# frozen_string_literal: true

class CreateOrder
  include Interactor

  def call
    prepare_order
    validate_order
    create_order
    finish_shopping_cart
  end

  private

  def prepare_order
    customer = context[:customer]
    address = context[:address]
    items = context[:items]
    @params = {
      customer_id: customer.id,
      customer_email: customer.email,
      address: address.address,
      front_door: address.front_door,
      floor: address.floor,
      intercom: address.intercom,
      item_ids: items
    }
  end

  def validate_order
    validate_result = context[:orchestrator_adapter].validate_order(@params)
    return unless validate_result.key?(:errors)

    context.fail!(validate_result[:errors])
  end

  def create_order
    create_result = context[:orchestrator_adapter].create_order(@params)
    return context.id = create_result[:data].id unless create_result.key?(:errors)

    context.fail!(create_result[:errors])
  end

  def finish_shopping_cart
    context[:shopping_cart].finish
  end
end
