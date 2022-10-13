User
  .business
  .limit(5)
  .each do |user|
    user.organizations.create(
      address:
        "長野県北安曇郡白馬村#{Faker::Address.unique.city} #{Faker::Number.number(digits: 3)}-#{Faker::Number.number(digits: 3)}",
      name: Faker::Company.unique.name,
      phone: Faker::Number.unique.leading_zero_number(digits: 10),
      slug: Faker::Internet.unique.domain_word
    )
  end
