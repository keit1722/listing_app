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

    factory :day_monday, traits: %i[monday]
    factory :day_tuesday, traits: %i[tuesday]
    factory :day_wednesday, traits: %i[wednesday]
    factory :day_thursday, traits: %i[thursday]
    factory :day_friday, traits: %i[friday]
    factory :day_saturday, traits: %i[saturday]
    factory :day_sunday, traits: %i[sunday]
    factory :day_holiday, traits: %i[holiday]
  end
end
