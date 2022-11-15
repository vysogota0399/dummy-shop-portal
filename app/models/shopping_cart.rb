class ShoppingCart < ApplicationRecord
  belongs_to :user

  has_many :shopping_cart_items
  has_many :items, through: :shopping_cart_items

  # текущая сумма заказа (руб) в корзине
  def current_cost
    items.sum(:cost_cops)/100.to_f
  end
end
