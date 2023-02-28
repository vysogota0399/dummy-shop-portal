class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shopping_cart

  def find_shopping_cart
    @shopping_cart = ShoppingCart.find_or_create_by(user: current_user)
    @shopping_cart_decorator = ShoppingCartDecorator.new(@shopping_cart)
    @shopping_cart_current_cost = @shopping_cart_decorator.current_cost
  end
end