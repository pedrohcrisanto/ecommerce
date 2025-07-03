require "rails_helper"

RSpec.describe ::CartItems::Create, type: :case do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let(:params) do
    {
      product_id: product.id,
      quantity: 2
    }
  end

  describe "#call" do
    context "when the cart item is created successfully" do
      it "returns a success result with the cart" do
        result = described_class.call(params: params, cart: cart)

        expect(result).to be_success

        expect(result.data[:cart]).to eq(cart)
        expect(cart.cart_items.count).to eq(1)
      end
    end

    context "when the product does not exist" do
      it "returns an error result" do
        params[:product_id] = -1 # Non-existent product ID

        result = described_class.call(params: params, cart: cart)

        expect(result).not_to be_success
        expect(result.data[:message]).to include("Couldn't find Product")
      end
    end

    context "when the quantity is invalid" do
      it "returns an error result" do
        params[:quantity] = -1 # Invalid quantity

        result = described_class.call(params: params, cart: cart)

        expect(result).not_to be_success
        expect(result.data[:message]).to include("Invalid Quantity")
      end
    end

    context "when the cart is not provided" do
      it "returns an error result" do
        result = described_class.call(params: params, cart: nil)

        expect(result).not_to be_success
        expect(result.data[:message]).to include("Invalid Cart")
      end
    end

    context "when the product already exists in the cart" do
      before do
        cart.cart_items.create(product: product, quantity: 1)
      end

      it "updates the quantity of the existing cart item" do
        result = described_class.call(params: params, cart: cart)

        expect(result).to be_success
        expect(result.data[:cart].cart_items.first.quantity).to eq(2)
        expect(cart.cart_items.count).to eq(1)
      end
    end
  end
end
