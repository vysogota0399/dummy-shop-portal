class CreateIntegrations < ActiveRecord::Migration[7.1]
  def change
    create_table :integrations do |t|
      t.string :host, null: false
      t.string :token
      t.string :code

      t.timestamps
    end

    add_index :integrations, :code, if_not_exists: true, unique: true
  end
end
