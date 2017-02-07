class CreateOrders < ActiveRecord::Migration[5.0]
  def change
    create_table :orders do |t|
      t.integer :subtotal
      t.integer :total
      t.integer :tax
      t.string :completed

      t.timestamps
    end
  end
end
