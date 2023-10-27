class ShoppingCartsController < AuthorizedController
  def update
    respond_to do |format|
      format.json do
        @shopping_cart.add_item(params[:id])
        render json: { new_cost: @shopping_cart.cost }
      end
    end
  end

  def show
    @items = @shopping_cart.current_items
  end
end
