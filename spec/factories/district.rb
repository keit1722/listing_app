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

    factory :district_uchiyama, traits: %i[uchiyama]
    factory :district_sano, traits: %i[sano]
  end
end
