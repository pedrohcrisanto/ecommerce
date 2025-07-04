class CartItemBlueprint < Blueprinter::Base
  identifier :id

  fields :quantity, :created_at, :updated_at

  association :product, blueprint: ProductBlueprint
  association :cart, blueprint: CartBlueprint
end