class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order

  def subtotal
    quantity * menu_item.price
  end
end
