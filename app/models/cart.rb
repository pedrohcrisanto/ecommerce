class Cart < ApplicationRecord
  # A cart_items has many cart_items items. If a cart_items is destroyed, its items should also be destroyed.
  has_many :cart_items, dependent: :destroy
  # Through association to easily get all products in a cart_items
  has_many :products, through: :cart_items

  # Validation for session_id, though it might be set dynamically
  validates :session_id, presence: true, uniqueness: true, allow_nil: true

  # Scope to find active cart_items (not abandoned)
  scope :active, -> { where(abandoned_at: nil) }
  # Scope to find abandoned cart_items
  scope :abandoned, -> { where.not(abandoned_at: nil) }

  # Method to calculate the total price of all items in the cart_items
  def total_price
    cart_items.sum(:total_price)
  end

  # Method to check if the cart_items is empty
  def empty?
    cart_items.empty?
  end

  # Method to mark the cart_items as abandoned
  def mark_as_abandoned!
    update(abandoned_at: Time.current) unless abandoned_at.present?
  end

  # Method to check if the cart_items is abandoned
  def abandoned?
    abandoned_at.present?
  end

  # Method to check if the cart_items has been abandoned for more than 7 days
  def abandoned_for_more_than_seven_days?
    abandoned_at.present? && abandoned_at < 7.days.ago
  end
end
