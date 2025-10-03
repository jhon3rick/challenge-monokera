# migracion para la tabla customers
class CreateCustomers < ActiveRecord::Migration[7.2]
  def change
    create_table :customers do |t|
      t.string :customer_name, null: false
      t.string :address
      t.integer :orders_count, default: 0, null: false
      t.timestamps
    end
  end
end
