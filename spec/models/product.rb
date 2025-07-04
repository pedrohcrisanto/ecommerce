require "rails_helper"

RSpec.describe ::Product, type: :model do
  it { should have_many(:cart_items).dependent(:destroy) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:unit_price) }
end
