# frozen_string_literal: true
class ItemsFilter < BaseFilter
  SORT_DIRECTION = %w[desc asc]
  SORT_BY = %w[cost_cops]
  SELECT_OPTIONS = Item.kinds.merge('all' => 'all')

  def call
    query
  end

  def query
    items = Item
    items = items.where(kind: params[:kind]) unless params[:kind] == SELECT_OPTIONS['all'] || params[:kind].nil?
    return items if params[:sort_by].blank? && params[:sort_direction].blank?

    items.order("#{params[:sort_by]} #{params[:sort_direction]}")
  end
end