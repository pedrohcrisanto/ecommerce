class CartBlueprint < Blueprinter::Base
  identifier :id

  association :products, blueprint: ::ProductBlueprint

  fields :total_price, :session_id
end
