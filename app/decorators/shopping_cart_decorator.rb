# frozen_string_literal: true

class ShoppingCartDecorator
  attr_reader :shopping_cart, :orchestrator_adapter

  def initialize(shopping_cart, orchestrator_adapter)
    @shopping_cart = shopping_cart
    @orchestrator_adapter = orchestrator_adapter
  end

  def empty?
    current_items.empty?
  end

  def add_item(id)
    shopping_cart.items << id
    shopping_cart.save
    shopping_cart
  end

  # Чистит корзину
  def clean
    shopping_cart.update(items: [])
  end

  def cost
    current_items.sum { |item, count| item.cost_rub * count }.round
  end

  # Товары в корзигне пользователя
  def current_items
    @current_items ||= begin
      prepared_item_ids = shopping_cart.items
      return [] unless prepared_item_ids.any?

      result = {}
      search_params = {
        id: prepared_item_ids,
        orchestrator_adapter: orchestrator_adapter,
      }
      found_items = ItemFinder.call(search_params).items
      found_items.each do |found_item|
        result[found_item] = prepared_item_ids.count { |prepared_id| prepared_id == found_item.id }
      end
      result
    end
  end
end
