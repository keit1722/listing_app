FactoryBot.define do
  factory :general_user, class: User do
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    username { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
  end

  factory :business_user, class: User do
    last_name { Faker::Name.last_name }
    first_name { Faker::Name.first_name }
    username { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
    role { 'business' }
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
