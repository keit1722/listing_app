FactoryBot.define do
  factory :organization_invitation do
    email { Faker::Internet.unique.email }
    expires_at { 24.hours.from_now }
  end
end

# == Schema Information
#
# Table name: organization_invitations
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  expires_at      :datetime         not null
#  status          :integer          default("untouched"), not null
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  inviter_id      :integer          not null
#  organization_id :bigint
#
# Indexes
#
#  index_organization_invitations_on_organization_id  (organization_id)
#  index_organization_invitations_on_token            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
