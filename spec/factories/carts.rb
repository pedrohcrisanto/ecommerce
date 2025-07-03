FactoryBot.define do
  factory :cart do
    session_id { SecureRandom.hex(10) }
    abandoned_at { nil }
  end
end
