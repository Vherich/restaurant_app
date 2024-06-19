class RemoveCategoryFromTables < ActiveRecord::Migration[7.1]
  def change
    remove_column :tables, :category, :integer
  end
end
