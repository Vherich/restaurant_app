class AddObservationsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :observations, :text
  end
end
