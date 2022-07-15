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
class OrganizationRegistration < ApplicationRecord
  validates :organization_name, presence: true
  validates :organization_address, presence: true
  validates :organization_phone, presence: true
  validates :business_detail, presence: true
end
