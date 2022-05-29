FactoryBot.define do
  factory :organization do
    name { Faker::Company.unique.name }
    address { Faker::Address.full_address }
    phone { Faker::PhoneNumber.phone_number.delete('-') }
    slug { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
  end
end
