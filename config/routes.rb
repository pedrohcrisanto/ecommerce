Rails.application.routes.draw do
  namespace :v1 do
    resources :carts, only: [ :create, :show, :update ] do
      delete ":product_id", to: "carts#destroy", on: :collection
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
