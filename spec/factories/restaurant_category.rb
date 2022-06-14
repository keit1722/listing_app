FactoryBot.define do
  factory :restaurant_category do
    trait :japanese_food do
      name { '和食' }
    end
    trait :chinese_food do
      name { '中華' }
    end

    factory :restaurant_category_japanese_food, traits: %i[japanese_food]
    factory :restaurant_category_chinese_food, traits: %i[chinese_food]
  end
end
