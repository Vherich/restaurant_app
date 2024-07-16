class AddOrderTypeToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :order_type, :integer
  end
end
