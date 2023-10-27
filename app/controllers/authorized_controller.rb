class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shopping_cart, if: -> { user_signed_in? }
  before_action :initialize_address

  def find_shopping_cart
    shopping_cart = ShoppingCart.find_or_create_by(user: current_user)
    @shopping_cart = ShoppingCartDecorator.new(shopping_cart, Thread.current[:orchestrator_adapter])
    @address = current_user.addresses.first_or_initialize
  end

  def initialize_address
    @address = user_signed_in? ? current_user.addresses.first_or_initialize : address.new
  end
end