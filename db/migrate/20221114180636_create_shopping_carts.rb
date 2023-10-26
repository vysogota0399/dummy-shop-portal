class CreateShoppingCarts < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_carts do |t|
      t.belongs_to :user
      t.bigint :items, array: true, default: []
      t.timestamps
    end
  end
end
