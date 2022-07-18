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
# Foreign Keys
#
#  fk_rails_...  (organization_registration_id => organization_registrations.id)
#
FactoryBot.define do
  factory :organization_registration_status do
  end
end
