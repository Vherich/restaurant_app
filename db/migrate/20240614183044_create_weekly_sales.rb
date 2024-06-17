class CreateWeeklySales < ActiveRecord::Migration[7.1]
  def change
    create_table :weekly_sales do |t|
      t.decimal :total_sales
      t.date :week_start

      t.timestamps
    end
  end
end
