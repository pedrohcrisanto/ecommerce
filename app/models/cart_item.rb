class CartItem < ApplicationRecord
  # A cart_items items belongs to a specific cart_items and a specific product
  belongs_to :cart
  belongs_to :product

  # Validations for quantity and prices
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Ensure uniqueness of product within a cart_items
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart_items" }

  # Callback to automatically set/update total_price before saving
  before_save :set_total_price

  private

  # Calculates the total price for this cart_items items based on quantity and unit_price
  def set_total_price
    self.total_price = quantity * unit_price
  end
end
