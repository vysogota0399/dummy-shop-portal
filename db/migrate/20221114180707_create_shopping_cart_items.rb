class CreateShoppingCartItems < ActiveRecord::Migration[7.0]
  def change
    create_table :shopping_cart_items do |t|
      t.belongs_to  :shopping_cart
      t.belongs_to  :item
      
      t.integer     :count
      t.timestamps
    end
  end
end
