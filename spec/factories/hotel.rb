FactoryBot.define do
  factory :hotel do
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

    after(:build) do |hotel|
      hotel.opening_hours << build(:day_monday)
      hotel.opening_hours << build(:day_tuesday)
      hotel.opening_hours << build(:day_wednesday)
      hotel.opening_hours << build(:day_thursday)
      hotel.opening_hours << build(:day_friday)
      hotel.opening_hours << build(:day_saturday)
      hotel.opening_hours << build(:day_sunday)
      hotel.opening_hours << build(:day_holiday)
      hotel.reservation_link = build(:reservation_link)
      hotel.page_show = build(:page_show)
    end
  end
end
