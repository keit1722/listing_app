FactoryBot.define do
  factory :organization_registration_status do
    trait :accepted do
      status { :accepted }
    end

    trait :rejected do
      status { :rejected }
    end

    factory :organization_registration_status_accepted, traits: [:accepted]
    factory :organization_registration_status_rejected, traits: [:rejected]
  end
end

# == Schema Information
#
# Table name: organization_registration_statuses
#
#  id                           :bigint           not null, primary key
#  status                       :integer          not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  organization_registration_id :bigint
#
# Indexes
#
#  index_org_registration_statuses_on_org_registration_id  (organization_registration_id)
#
