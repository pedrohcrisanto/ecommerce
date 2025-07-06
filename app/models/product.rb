class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  def total_price
    unit_price * quantity
  end
  def quantity
    cart_items.sum(:quantity)
  end
end
