class CartItem < ApplicationRecord
  # A cart_items items belongs to a specific cart_items and a specific product
  belongs_to :cart
  belongs_to :product

  # Validations for quantity and prices
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  # Ensure uniqueness of product within a cart_items
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart_items" }
end
