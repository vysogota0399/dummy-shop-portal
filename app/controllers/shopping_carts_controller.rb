class ShoppingCartsController < AuthorizedController
  def update
    respond_to do |format|
      format.turbo_stream do
        case params[:item_action]
        when 'remove_items'
          @shopping_cart.remove_items_by(params[:item_id])
        else
          @shopping_cart.add_item(params[:item_id])
        end
        render :update
      end
    end
  end

  def show; end
end
