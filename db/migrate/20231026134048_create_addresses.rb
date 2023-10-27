class CreateAddresses < ActiveRecord::Migration[7.1]
  def change
    create_table :addresses do |t|
      t.string :address
      t.string :front_door
      t.string :floor
      t.string :intercom

      t.belongs_to :user
      t.timestamps
    end
  end
end
