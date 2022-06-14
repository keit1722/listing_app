FactoryBot.define do
  factory :activity do
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

    after(:build) do |activity|
      activity.opening_hours << build(:day_monday)
      activity.opening_hours << build(:day_tuesday)
      activity.opening_hours << build(:day_wednesday)
      activity.opening_hours << build(:day_thursday)
      activity.opening_hours << build(:day_friday)
      activity.opening_hours << build(:day_saturday)
      activity.opening_hours << build(:day_sunday)
      activity.opening_hours << build(:day_holiday)
      activity.reservation_link = build(:reservation_link)
    end
  end
end
