FactoryBot.define do
  factory :restaurant do
    address { Faker::Address.full_address }
    description { Faker::Lorem.paragraph(sentence_count: 10) }
    lat { Faker::Number.between(from: -85, to: 85) }
    lng { Faker::Number.between(from: -180, to: 180) }
    name { Faker::Company.unique.name }
    slug { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    images do
      [Rack::Test::UploadedFile.new('spec/fixtures/fixture.png', 'image/png')]
    end

    organization

    after(:build) do |restaurant|
      restaurant.opening_hours << build(:day_monday)
      restaurant.opening_hours << build(:day_tuesday)
      restaurant.opening_hours << build(:day_wednesday)
      restaurant.opening_hours << build(:day_thursday)
      restaurant.opening_hours << build(:day_friday)
      restaurant.opening_hours << build(:day_saturday)
      restaurant.opening_hours << build(:day_sunday)
      restaurant.opening_hours << build(:day_holiday)
      restaurant.reservation_link = build(:reservation_link)
    end
  end
end
