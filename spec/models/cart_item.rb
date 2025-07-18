require "rails_helper"
RSpec.describe ::CartItem, type: :model do
  it { should belong_to(:cart) }
  it { should belong_to(:product) }
  it { should validate_presence_of(:quantity) }
  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(1) }
end
