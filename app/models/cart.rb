class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :products, through: :cart_items

  validates :session_id, presence: true, uniqueness: true

  scope :active, -> { where(abandoned_at: nil) }
  scope :abandoned, -> { where.not(abandoned_at: nil) }

  def empty?
    cart_items.empty?
  end

  # Method to mark the cart as abandoned
  def mark_as_abandoned!
    update(abandoned_at: Time.current) unless abandoned_at.present?
  end

  # Method to check if the cart is abandoned
  def abandoned?
    abandoned_at.present?
  end

  # Method to check if the cart has been abandoned for more than 7 days
  def abandoned_for_more_than_seven_days?
    abandoned_at.present? && abandoned_at < 7.days.ago
  end

  def total_price
    cart_items.includes(:product).sum('cart_items.quantity * products.unit_price')
  end
end
