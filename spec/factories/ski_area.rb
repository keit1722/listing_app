FactoryBot.define do
  factory :ski_area do
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

    after(:build) do |ski_area|
      ski_area.opening_hours << build(:day_monday)
      ski_area.opening_hours << build(:day_tuesday)
      ski_area.opening_hours << build(:day_wednesday)
      ski_area.opening_hours << build(:day_thursday)
      ski_area.opening_hours << build(:day_friday)
      ski_area.opening_hours << build(:day_saturday)
      ski_area.opening_hours << build(:day_sunday)
      ski_area.opening_hours << build(:day_holiday)
      ski_area.reservation_link = build(:reservation_link)
      ski_area.page_show = build(:page_show)
    end
  end
end
