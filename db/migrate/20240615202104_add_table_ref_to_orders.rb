class AddTableRefToOrders < ActiveRecord::Migration[7.1]
  def change
    add_reference :orders, :table, null: false, foreign_key: true
  end
end
