class AddTableToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :table, :string
  end
end
