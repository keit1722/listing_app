FactoryBot.define do
  factory :district do
    trait :uchiyama do
      name { '内山' }
      location { 'hakuba' }
    end
    trait :sano do
      name { '佐野' }
      location { 'hakuba' }
    end
    trait :meitetsu do
      name { 'めいてつ' }
      location { 'hakuba' }
    end

    factory :district_uchiyama, traits: [:uchiyama]
    factory :district_sano, traits: [:sano]
    factory :district_meitetsu, traits: [:meitetsu]
  end
end
