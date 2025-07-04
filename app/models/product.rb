class Product < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  # You might want to add validations here too
  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :unit_price, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # For demonstration, let's add some mock product data (you'd seed this in db/seeds.rb)
  # self.abstract_class = true # If Product is just an interface for external products
  def total_price
    unit_price * quantity
  end

  def quantity
    cart_items.sum(:quantity)
  end
end
