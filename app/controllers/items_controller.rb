class ItemsController < ApplicationController
  include Pagy::Backend

  before_action :find_items

  def index; end

  private
  
  def find_items
    @pagy, @items = pagy(ItemsFilter.call(params))
  end
end