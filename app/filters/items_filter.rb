class ItemsFilter < BaseFilter
  def call
    query
  end

  def query
    Item.all
  end
end