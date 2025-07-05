require "rails_helper"
RSpec.describe ::Cart::AddItem, type: :case do
  let(:cart) { create(:cart) }
  let(:cart_item) { create(:cart_item, cart: cart, product: product) }
  let(:product) { create(:product) }
  let(:params) { { product_id: product.id, quantity: 2 } }

  subject { described_class.call(params: params, cart: cart) }

  context "when adding a valid product to the cart" do
    it "successfully adds the product" do
      expect(subject).to be_success
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.product_id).to eq(product.id)
      expect(cart.cart_items.first.quantity).to eq(2)
    end
  end

  context "when adding a product that is already in the cart" do
    before do
      cart.cart_items.create(product: product, quantity: 1)
    end

    it "increases the quantity of the existing item" do
      expect(subject).to be_failure
      expect(cart.cart_items.count).to eq(1)
      expect(cart.cart_items.first.quantity).to eq(1)
    end
  end

  context "when adding an invalid product" do
    let(:params) { { product_id: nil, quantity: 2 } }

    it "returns an error" do
      expect(subject).to be_failure
      expect(subject.data[:message]).to include("Couldn't find Product without an ID")
    end

    it "does not change the cart items" do
      expect(cart.cart_items.count).to eq(0)
    end
  end
end
