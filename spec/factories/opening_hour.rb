FactoryBot.define do
  factory :opening_hour do
    closed { false }
    start_time_hour { 9 }
    start_time_minute { '00' }
    end_time_hour { 17 }
    end_time_minute { '00' }

    trait :monday do
      day { :monday }
    end
    trait :tuesday do
      day { :tuesday }
    end
    trait :wednesday do
      day { :wednesday }
    end
    trait :thursday do
      day { :thursday }
    end
    trait :friday do
      day { :friday }
    end
    trait :saturday do
      day { :saturday }
    end
    trait :sunday do
      day { :sunday }
    end
    trait :holiday do
      day { :holiday }
    end

    factory :day_monday, traits: [:monday]
    factory :day_tuesday, traits: [:tuesday]
    factory :day_wednesday, traits: [:wednesday]
    factory :day_thursday, traits: [:thursday]
    factory :day_friday, traits: [:friday]
    factory :day_saturday, traits: [:saturday]
    factory :day_sunday, traits: [:sunday]
    factory :day_holiday, traits: [:holiday]
  end
end
