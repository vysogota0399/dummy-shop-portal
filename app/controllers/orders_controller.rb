# frozen_string_literal: true

class OrdersController < AuthorizedController
  include Pagy::Backend

  def index
    # @orders = orchestrator_adapter.orders(customer_id: current_user.id)
  end

  def create
    order_params = params.merge(customer_id: current_user.id)
    orchestrator_adapter.create_order(params.permit!.to_h)
    @shopping_cart.clean
    flash[:success] = 'Заказ успешно оформлен!'

    redirect_to orders_path
  end
end
