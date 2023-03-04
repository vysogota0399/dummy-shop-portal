class AuthorizedController < ApplicationController
  before_action :authenticate_user!
  before_action :find_shopping_cart

  rescue_from Orchestrator::Errors::BadRequest, with: :bad_request_allert
  rescue_from Orchestrator::Errors::InternalServerError, with: :internal_error_allert

  def find_shopping_cart
    @shopping_cart = ShoppingCart.find_or_create_by(user: current_user)
    @shopping_cart_decorator = ShoppingCartDecorator.new(@shopping_cart)
    @shopping_cart_current_cost = @shopping_cart_decorator.current_cost
  end

  def orchestrator_adapter
    Orchestrator::Adapter
  end

  private

  def bad_request_allert
    redirect_to root_path
    flash[:danger] = 'В момент выполнения операции произошла ошибка'
  end

  alias_method :internal_error_allert, :bad_request_allert
end