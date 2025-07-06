require "rails_helper"

RSpec.describe ::MarkAbandonedCartsWorker, type: :worker do
  describe "#perform" do
    let!(:cart) { create(:cart, abandoned_at: nil, updated_at: 4.hours.ago) }
    let!(:recent_cart) { create(:cart, abandoned_at: nil, updated_at: 1.hour.ago) }

    it "marks carts as abandoned if they were not updated in the last 3 hours" do
      expect {
        described_class.new.perform
      }.to change { cart.reload.abandoned_at }.from(nil).to(be_within(1.second).of(Time.current))

      expect(recent_cart.reload.abandoned_at).to be_nil
    end

    it "logs completion message" do
      expect(Rails.logger).to receive(:info).with("[MarkAbandonedCartsJob] Concluído.")
      described_class.new.perform
    end
  end
end
