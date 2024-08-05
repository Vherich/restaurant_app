class AddTableIdToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :table_id, :integer
    add_foreign_key :orders, :tables
  end
end
