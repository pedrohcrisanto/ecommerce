class CartItem < ApplicationRecord
  # A cart item belongs to a specific cart and a specific product
  belongs_to :cart
  belongs_to :product

  # Validations for quantity and prices
  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 0, only_integer: true }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Ensure uniqueness of product within a cart
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart" }

  # Callback to automatically set/update total_price before saving
  before_save :set_total_price

  private

  # Calculates the total price for this cart item based on quantity and unit_price
  def set_total_price
    self.total_price = quantity * unit_price
  end
end
