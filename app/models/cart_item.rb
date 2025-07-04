class CartItem < ApplicationRecord
  # A cart items belongs to a specific cart and a specific product
  belongs_to :cart
  belongs_to :product

  # Validations for quantity and prices
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }

  # Ensure uniqueness of product within a cart
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart" }
end
