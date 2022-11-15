class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.bigint  :performer_id
      t.bigint  :customer_id
      t.integer :cost_cops
      t.string  :comment
      t.integer :evaluation
      t.integer :status
      t.timestamps
    end
  end
end
