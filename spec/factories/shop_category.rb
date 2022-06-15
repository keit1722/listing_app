FactoryBot.define do
  factory :shop_category do
    trait :souvenir do
      name { 'お土産' }
    end
    trait :sports_shop do
      name { 'スポーツショップ' }
    end

    factory :shop_category_souvenir, traits: [:souvenir]
    factory :shop_category_sports_shop, traits: [:sports_shop]
  end
end
