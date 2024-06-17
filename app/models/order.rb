class Order < ApplicationRecord
  belongs_to :table
  has_many :order_items
  has_many :menu_items, through: :order_items
  validates :table, presence: true, inclusion: { in: (1..20).to_a }
  scope :current, -> { where(status: ['pending', 'ready']) }
  scope :completed, -> { where(status: 'completed') }
  def status_badge_class
    case status
    when 'pending' then 'warning'
    when 'ready' then 'info'
    when 'completed' then 'success'
    else 'secondary'
    end
  end
end
