class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shopping_cart

  def find_shopping_cart
    @shopping_cart = ShoppingCart.find_or_create_by(user: current_user)
  end
end