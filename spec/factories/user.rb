FactoryBot.define do
  factory :user do
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    username { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :genereal do
      role { :general }
    end

    trait :business do
      role { :business }
    end

    trait :activated do
      after(:create) { |user| user.activate! }
    end

    factory :general_user, traits: [:genereal]
    factory :business_user, traits: [:business]
  end
end
