require "rails_helper"

RSpec.describe ::CartItems::Destroy, type: :case do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }

  describe "#call" do
    context "when the cart item exists" do
      it "successfully removes the cart item" do
        result = described_class.call(product_id: product.id, cart: cart)

        expect(result).to be_success
        expect(result.data[:message]).to eq("Cart item successfully removed.")
        expect(cart.cart_items.count).to eq(0)
      end
    end

    context "when the cart item does not exist" do
      it "returns an error result" do
        result = described_class.call(product_id: -1, cart: cart) # Non-existent product ID

        expect(result).not_to be_success
        expect(result.data[:message]).to include("Cart item not found")
      end
    end
  end
end
