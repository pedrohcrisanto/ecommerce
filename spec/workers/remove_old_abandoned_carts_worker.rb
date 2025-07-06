require "rails_helper"
RSpec.describe ::RemoveOldAbandonedCartsWorker, type: :worker do
  describe "#perform" do
    let!(:abandoned_cart) { create(:cart, abandoned_at: 8.days.ago) }
    let!(:recent_cart) { create(:cart, abandoned_at: nil) }

    it "removes carts that were abandoned more than 3 hours ago" do
      described_class.new.perform

      expect(Cart.exists?(abandoned_cart.id)).to be_falsey
      expect(Cart.exists?(recent_cart.id)).to be_truthy
    end
  end
end
