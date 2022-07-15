FactoryBot.define do
  factory :organization_invitation do
    email { Faker::Internet.unique.email }
    expires_at { Time.current + 6.hours }
  end
end
