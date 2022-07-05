# == Schema Information
#
# Table name: organization_invitations
#
#  id              :bigint           not null, primary key
#  accepted        :boolean          default(FALSE), not null
#  email           :string           not null
#  expires_at      :datetime         not null
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
class OrganizationInvitation < ApplicationRecord
  belongs_to :organization

  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i,
            }
  validates :inviter_id, presence: true
  validates :token, presence: true, uniqueness: true
  validates :expires_at, presence: true

  before_save { self.email = email.downcase }
end
