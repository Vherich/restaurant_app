class Dish < ApplicationRecord
  belongs_to :order
  attribute :dish_type, :integer # or whichever type you want
  # Explicitly declare the dish_type enum
  enum dish_type: {
    prato_por_quilo: 0,
    # ... (other dish types if needed)
  }
end
