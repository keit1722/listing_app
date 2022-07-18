# == Schema Information
#
# Table name: organization_registrations
#
#  id                   :bigint           not null, primary key
#  business_detail      :text             not null
#  organization_address :string           not null
#  organization_name    :string           not null
#  organization_phone   :string           not null
#  token                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint
#
# Indexes
#
#  index_organization_registrations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :organization_registration do
    organization_name { Faker::Company.unique.name }
    organization_address { Faker::Address.full_address }
    organization_phone { Faker::PhoneNumber.phone_number.delete('-') }
    business_detail do
      Faker::Lorem.paragraph_by_chars(number: 200, supplemental: false)
    end
  end
end
