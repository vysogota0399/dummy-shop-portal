# frozen_string_literal: true

class ShoppingCartDecorator
  attr_reader :shopping_cart

  def initialize(shopping_cart)
    @shopping_cart = shopping_cart
  end

  def add_item(id)
    shopping_cart.update(items: current_item_ids << id)
  end

  # текущая сумма заказа (руб) в корзине
  def current_cost
    items = adapter.get_items(id: current_item_ids)[:items]
    current_items.sum { |item| item.cost_rub }
  end

  def current_items
    ids = current_item_ids
    return [] unless ids.any?

    items = adapter.get_items(id: ids)[:items]
    items_hash = {}
    items.each do |item|
      items_hash[item.id] = item
    end

    ids.map do |id|
      items_hash[id]
    end
  end

  private

  def adapter
    Orchestrator::Adapter
  end

  def current_item_ids
    shopping_cart.items || []
  end
end