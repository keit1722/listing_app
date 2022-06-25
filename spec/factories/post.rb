FactoryBot.define do
  factory :post do
    title { Faker::Company.unique.name }
    body { Faker::Company.unique.name }
    image do
      Rack::Test::UploadedFile.new('spec/fixtures/fixture.png', 'image/png')
    end

    trait :published do
      status { :published }
    end
    trait :draft do
      status { :draft }
    end

    factory :post_published, traits: [:published]
    factory :post_draft, traits: [:draft]
  end
end
