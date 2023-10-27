
class ItemsController < AuthorizedController
  include Pagy::Backend

  def index
    items_with_meta = ItemFinder.call(filter_strong_params.to_h.merge(orchestrator_adapter: Thread.current[:orchestrator_adapter]))
    @items = items_with_meta.items
    meta = items_with_meta.meta
    @pagy = Pagy.new(count: meta.count, page: meta.page)
  end

  private

  def filter_strong_params
    params.permit(:kind, :order_direction, :order_by)
  end
end
