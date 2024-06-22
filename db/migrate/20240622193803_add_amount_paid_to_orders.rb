class AddAmountPaidToOrders < ActiveRecord::Migration[7.0]
  def change
    add_column :orders, :amount_paid, :decimal, precision: 10, scale: 2
  end
end
