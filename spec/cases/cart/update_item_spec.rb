require "rails_helper"
RSpec.describe ::Cart::UpdateItem, type: :case do
  let(:cart) { create(:cart) }
  let(:product) { create(:product) }
  let!(:cart_item) { create(:cart_item, cart: cart, product: product, quantity: 1) }
  let(:params) { { product_id: product.id, quantity: 2 } }

  subject { described_class.call(params: params, cart: cart) }

  context "when updating the quantity of an existing item" do
    it "successfully updates the quantity" do
      expect(subject).to be_success
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(2)
    end
  end

  context "when setting the quantity to zero" do
    let(:params) { { product_id: product.id, quantity: 0 } }

    it "removes the item from the cart" do
      expect(subject).to be_success
      expect(cart.cart_items.count).to eq(0)
    end
  end

  context "when updating a non-existent product" do
    let(:params) { { product_id: -1, quantity: 2 } }

    it "returns an error" do
      expect(subject).not_to be_success
      expect(subject.data[:message]).to include("Couldn't find Product")
    end

    it "does not change the cart items" do
      expect(cart.cart_items.count).to eq(1)
    end
  end

  context "when updating with nil quantity parameter" do
    let(:params) { { product_id: product.id, quantity: nil } }

    it "removes the product" do
      expect(subject).to be_success
      expect(subject.data[:message]).to include("Product removed from cart.")
    end

    it "does not change the cart items" do
      expect(cart.cart_items.count).to eq(1)
    end
  end
end
