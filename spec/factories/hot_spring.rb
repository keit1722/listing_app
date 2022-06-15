FactoryBot.define do
  factory :hot_spring do
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

    after(:build) do |hot_spring|
      hot_spring.opening_hours << build(:day_monday)
      hot_spring.opening_hours << build(:day_tuesday)
      hot_spring.opening_hours << build(:day_wednesday)
      hot_spring.opening_hours << build(:day_thursday)
      hot_spring.opening_hours << build(:day_friday)
      hot_spring.opening_hours << build(:day_saturday)
      hot_spring.opening_hours << build(:day_sunday)
      hot_spring.opening_hours << build(:day_holiday)
    end
  end
end
