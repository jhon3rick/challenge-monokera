# migracion para la tabla orders
class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.integer :customer_id, null: false
      t.string  :product_name, null: false
      t.integer :quantity, null: false
      t.decimal :price, precision: 12, scale: 2, null: false
      t.string  :status, default: 'pending'
      t.string  :customer_name
      t.string  :customer_address
      t.timestamps
    end
    add_index :orders, :customer_id
  end
end