class AddPrintedAtToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :printed_at, :datetime
  end
end
