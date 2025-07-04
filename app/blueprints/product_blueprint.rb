class ProductBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :quantity, :unit_price

  field :total_price do |product|
    product.unit_price * product.quantity
  end
end
