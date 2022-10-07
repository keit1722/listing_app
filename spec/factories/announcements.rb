FactoryBot.define do
  factory :announcement do
    title { Faker::Company.unique.name }
    body { Faker::Lorem.paragraph(sentence_count: 10) }
    image do
      Rack::Test::UploadedFile.new('spec/fixtures/fixture.png', 'image/png')
    end

    trait :published do
      status { :published }
    end
    trait :draft do
      status { :draft }
    end

    factory :announcement_published, traits: [:published]
    factory :announcement_draft, traits: [:draft]
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  published_before :boolean          default(FALSE), not null
#  status           :integer          default("published"), not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  poster_id        :integer          not null
#
