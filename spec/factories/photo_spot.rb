FactoryBot.define do
  factory :photo_spot do
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
  end
end
