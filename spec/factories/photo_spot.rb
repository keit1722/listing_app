FactoryBot.define do
  factory :photo_spot do
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

    after(:build) do |photo_spot|
      photo_spot.opening_hours << build(:day_monday)
      photo_spot.opening_hours << build(:day_tuesday)
      photo_spot.opening_hours << build(:day_wednesday)
      photo_spot.opening_hours << build(:day_thursday)
      photo_spot.opening_hours << build(:day_friday)
      photo_spot.opening_hours << build(:day_saturday)
      photo_spot.opening_hours << build(:day_sunday)
      photo_spot.opening_hours << build(:day_holiday)
      photo_spot.reservation_link = build(:reservation_link)
      photo_spot.page_show = build(:page_show)
    end
  end
end
