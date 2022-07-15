FactoryBot.define do
  factory :organization_invitation do
    email { Faker::Internet.unique.email }
    expires_at { 6.hours.from_now }
  end
end
