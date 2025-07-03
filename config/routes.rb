Rails.application.routes.draw do
  namespace :v1 do
    post '/cart', to: 'carts#add_item', as: :add_to_cart
    get '/cart', to: 'carts#show', as: :show_cart
    patch '/cart/add_item', to: 'carts#update_item_quantity', as: :update_cart_item_quantity
    delete '/cart/:product_id', to: 'carts#remove_item', as: :remove_from_cart
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
