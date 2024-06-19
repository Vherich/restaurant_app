class Table < ApplicationRecord
  has_many :orders
  has_and_belongs_to_many :menu_items
end
