class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, presence: true, numericality: { greater_than_or_equal_to: 1, only_integer: true }
  validates :product_id, uniqueness: { scope: :cart_id, message: "already exists in this cart" }

  after_save :active_cart
  after_update :active_cart

  private
  def active_cart
    cart.update(abandoned_at: nil) if cart.abandoned_at.present?

    cart.update(updated_at: Time.current)
  end
end
