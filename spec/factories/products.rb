FactoryBot.define do
  factory :product do
    name { Faker::Name.name }
    unit_price { Random.rand(1.0..100.0).round(2) }
  end
end