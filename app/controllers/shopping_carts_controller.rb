class ShoppingCartsController < AuthorizedController
  def update
    respond_to do |format|
      format.html {}
      format.json do
        @shopping_cart.items << Item.find(params['id'])
        render :json => { new_cost: @shopping_cart.current_cost }
      end
    end
  end

  def show; end
end