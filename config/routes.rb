Rails.application.routes.draw do
  namespace :v1 do
    post '/cart_items', to: 'cart_items#add_item', as: :add_to_cart
    get '/cart_items', to: 'cart_items#show', as: :show_cart
    patch '/cart_items/add_item', to: 'cart_items#update_item_quantity', as: :update_cart_item_quantity
    delete '/cart_items/:product_id', to: 'cart_items#remove_item', as: :remove_from_cart
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
