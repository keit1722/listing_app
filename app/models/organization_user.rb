# == Schema Information
#
# Table name: organization_users
#
#  id              :bigint           not null, primary key
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_organization_users_on_organization_id              (organization_id)
#  index_organization_users_on_user_id                      (user_id)
#  index_organization_users_on_user_id_and_organization_id  (user_id,organization_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (user_id => users.id)
#
class OrganizationUser < ApplicationRecord
  validates :user_id, uniqueness: { scope: :organization_id }
end
