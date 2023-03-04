
class ItemsController < AuthorizedController
  include Pagy::Backend

  def index
    items_data = orchestrator_adapter.get_items(params.merge(with_meta: true))
    pagination_data = items_data[:pagination]
    @items          = items_data[:items]
    @pagy           = Pagy.new(count: pagination_data[:count], page: pagination_data[:page])
    @item_kinds     = items_data.dig(:meta, :select_options)
    @sort_direction = items_data.dig(:meta, :sort_direction)
    @sort_by        = items_data.dig(:meta, :sort_by)
  end
end
