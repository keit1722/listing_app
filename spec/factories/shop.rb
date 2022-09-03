FactoryBot.define do
  factory :shop do
    address { Faker::Address.full_address }
    description { Faker::Lorem.paragraph(sentence_count: 10) }
    lat { Faker::Number.between(from: -85, to: 85) }
    lng { Faker::Number.between(from: -180, to: 180) }
    name { Faker::Company.unique.name }
    slug { Faker::Alphanumeric.unique.alphanumeric(number: 10) }
    main_image do
      Rack::Test::UploadedFile.new('spec/fixtures/fixture.png', 'image/png')
    end

    organization

    after(:build) do |shop|
      shop.opening_hours << build(:day_monday)
      shop.opening_hours << build(:day_tuesday)
      shop.opening_hours << build(:day_wednesday)
      shop.opening_hours << build(:day_thursday)
      shop.opening_hours << build(:day_friday)
      shop.opening_hours << build(:day_saturday)
      shop.opening_hours << build(:day_sunday)
      shop.opening_hours << build(:day_holiday)
    end
  end
end
