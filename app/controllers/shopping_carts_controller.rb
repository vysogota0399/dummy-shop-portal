class ShoppingCartsController < AuthorizedController
  def update
    respond_to do |format|
      format.html {}
      format.json do
        @shopping_cart_decorator.add_item(params[:id])
        render :json => { new_cost: @shopping_cart_decorator.current_cost }
      end
    end
  end

  def show
    @items = @shopping_cart_decorator.current_items
  end
end