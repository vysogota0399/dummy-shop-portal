# frozen_string_literal: true

class ItemsDecorator
  attr_reader :items

  def self.group(items, &block)
    items = items.group_by { |item| item.id }
    grouped_items = items.map { |_id, group| [group.first, group.count] }
    return grouped_items unless block

    grouped_items.each do |item, count|
      block.call(item, count)
    end
  end
end