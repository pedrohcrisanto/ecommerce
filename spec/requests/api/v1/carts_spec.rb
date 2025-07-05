require "swagger_helper"
require "rails_helper"
RSpec.describe "V1 CARTS", type: :request do
  path "/api/v1/carts" do
    post "Create a new CartItem" do
      tags "Carts"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer },
          quantity: { type: :integer }
        },
        required: [ "product_id", "quantity" ]
      }
      let(:product) { create(:product) }

      response "201", "CartItem created" do
        let(:params) { { product_id: product.id, quantity: 1 } }

        run_test!
      end

      response "422", "Invalid request" do
        let(:params) { { product_id: nil, quantity: nil } }
        schema type: :object,
                properties: {
                  message: { type: :string }
                }


        run_test!
      end
    end

    get "Show Cart" do
      tags "Carts"
      produces "application/json"

      response "200", "Cart retrieved" do
        schema type: :object,
                properties: {
                  data: { type: :object, properties: { id: { type: :integer }, total_price: { type: :number } } },
                  message: { type: :string }
                }

        run_test!
      end
    end

    put "Update CartItem" do
      tags "Carts"
      consumes "application/json"
      produces "application/json"

      parameter name: :params, in: :body, schema: {
        type: :object,
        properties: {
          product_id: { type: :integer },
          quantity: { type: :integer }
        },
        required: [ "product_id", "quantity" ]
      }
      let(:product) { create(:product) }
      let!(:cart_item) { create(:cart_item, product: product, quantity: 1) }
      let(:cart) { create(:cart, cart_items: [ cart_item ]) }

      before do
        allow_any_instance_of(Api::V1::CartsController).to receive(:current_cart).and_return(cart)
      end

      response "200", "CartItem updated" do
        let(:params) { { product_id: product.id, quantity: 2 } }

        run_test!
      end

      response "422", "Invalid request" do
        let(:params) { { product_id: nil, quantity: nil } }
        schema type: :object,
                properties: {
                  message: { type: :string }
                }


        run_test!
      end
    end
  end

  path "/api/v1/carts/{product_id}" do
    delete "Remove CartItem" do
      tags "Carts"
      produces "application/json"

      parameter name: :product_id, in: :path, type: :string, description: "ID of the product to remove"

      let(:product) { create(:product) }
      let!(:cart_item) { create(:cart_item, product: product, quantity: 1) }
      let(:cart) { create(:cart, cart_items: [ cart_item ]) }

      before do
        allow_any_instance_of(Api::V1::CartsController).to receive(:current_cart).and_return(cart)
      end

      response "200", "CartItem removed" do
        let(:product_id) { product.id }
        schema type: :object,
                properties: {
                  data: { type: :object, properties: { id: { type: :integer }, total_price: { type: :number } } },
                  message: { type: :string }
                }

        run_test!
      end

      response "422", "Invalid request" do
        let(:product_id) { -1 }
        schema type: :object,
                properties: {
                  message: { type: :string }
                }

        run_test!
      end
    end
  end
end
