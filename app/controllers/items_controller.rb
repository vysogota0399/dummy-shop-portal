class ItemsController < AuthorizedController
  include Pagy::Backend

  before_action :find_items

  def index
    @item_kinds     = ItemsFilter::SELECT_OPTIONS
    @sort_direction = ItemsFilter::SORT_DIRECTION
    @sort_by        = ItemsFilter::SORT_BY
  end

  private
  
  def find_items
    @pagy, @items = pagy(ItemsFilter.call(params))
  end
end