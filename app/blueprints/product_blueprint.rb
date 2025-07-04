class ProductBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :quantity, :unit_price, :total_price
end
