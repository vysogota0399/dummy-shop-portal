# frozen_string_literal: true

class OrdersController < AuthorizedController
  def index
    respond_to do |format|
      format.html do
        filter = params[:filter]
        orders_finder = Proc.new {
          OrdersFinder.call(
            orchestrator_adapter: Thread.current[:orchestrator_adapter],
            customer_id: current_user.id,
            filter: { state: filter }
          )
        }
        case filter
        when 'active'
          @orders = orders_finder.call.orders
          return render 'orders/active_orders' 
        when 'finished' 
          @orders = orders_finder.call.orders
          return render 'orders/finished_orders' 
        end
      end
    end
  end

  def create
    respond_to do |format|
      format.html do
        order = CreateOrder.call(
          customer: current_user,
          items: @shopping_cart.current_item_ids,
          address: @address,
          orchestrator_adapter: Thread.current[:orchestrator_adapter],
          shopping_cart: @shopping_cart
        )
        if order.success?
          flash[:notice] = 'order.create_success'
        else
          flash[:error] = 'order.create_failure'
        end

        redirect_to root_path
      end
    end
  end
end
