require "rails_helper"
RSpec.describe ::Cart, type: :model do
  it { should have_many(:cart_items).dependent(:destroy) }
  it { is_expected.to have_many(:products).through(:cart_items) }
  it { should validate_presence_of(:session_id) }
  it { should validate_uniqueness_of(:session_id) }
end
