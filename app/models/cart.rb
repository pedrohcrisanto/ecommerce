class Cart < ApplicationRecord
  # A cart has many cart items. If a cart is destroyed, its items should also be destroyed.
  has_many :cart_items, dependent: :destroy
  # Through association to easily get all products in a cart
  has_many :products, through: :cart_items

  # Validation for session_id, though it might be set dynamically
  validates :session_id, presence: true, uniqueness: true, allow_nil: true

  # Scope to find active cart (not abandoned)
  scope :active, -> { where(abandoned_at: nil) }
  # Scope to find abandoned cart
  scope :abandoned, -> { where.not(abandoned_at: nil) }

  # Method to calculate the total price of all items in the cart
  def total_price
    cart_items.sum(:total_price)
  end

  # Method to check if the cart is empty
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
end
