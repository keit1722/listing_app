FactoryBot.define do
  factory :reservation_link do
    link { Faker::Internet.url }
  end
end
