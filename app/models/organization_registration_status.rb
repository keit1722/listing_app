# == Schema Information
#
# Table name: organization_registration_statuses
#
#  id                           :bigint           not null, primary key
#  status                       :boolean          not null
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
class OrganizationRegistrationStatus < ApplicationRecord
  belongs_to :organization_registration

  validates :status, presence: true

  enum status: { accepted: 1, rejected: 2 }
end
