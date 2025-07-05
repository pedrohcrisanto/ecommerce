require 'sidekiq/web'

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  namespace :api do
    namespace :v1 do
      resources :carts, only: [ :create ] do
        delete ":product_id", to: "carts#destroy", on: :collection
        get "/", to: "carts#show", on: :collection
        put "/", to: "carts#update", on: :collection
      end
    end
  end

  mount Sidekiq::Web => '/sidekiq'

  get "up" => "rails/health#show", as: :rails_health_check
end
