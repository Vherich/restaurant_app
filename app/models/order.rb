class Order < ApplicationRecord
  belongs_to :table
  has_many :order_items, inverse_of: :order, dependent: :destroy
  accepts_nested_attributes_for :order_items, allow_destroy: true, reject_if: :all_blank
  has_many :menu_items, through: :order_items
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
  before_create :set_default_status

  def printed?
    printed_at.present? # Check if printed_at has a value (meaning it's been printed)
  end

  def mark_as_printed
    update(printed_at: Time.now)
  end

  def total
    order_items.sum { |item| item.menu_item.price * item.quantity }
  end

  def calculate_change(amount_paid)
    [0, amount_paid - total].max # Ensure change is never negative
  end

  enum order_type: { presencial: 0, entrega: 1 }

  private

  def set_default_status
    self.status = 'pending' # or self.status = 'pending' if you're not using an enum
  end
end
