class CategoriesController < AuthorizedController
  def show
    @category = params[:id]
    filter_params = {
      orchestrator_adapter: Thread.current[:orchestrator_adapter],
      kind: @category
    }
    items_with_meta = ItemsFinder.call(filter_params)
    @items = items_with_meta.items
    meta = items_with_meta.meta
    @pagy = Pagy.new(count: meta.count, page: meta.page)
  end
end
