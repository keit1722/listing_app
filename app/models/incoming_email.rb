class IncomingEmail < ApplicationRecord
  validates :announcement, presence: true
  validates :organization, presence: true
  validates :organization_invitation, presence: true
  validates :post, presence: true
end

# == Schema Information
#
# Table name: incoming_emails
#
#  id                      :bigint           not null, primary key
#  announcement            :boolean          default(TRUE), not null
#  organization            :boolean          default(TRUE), not null
#  organization_invitation :boolean          default(TRUE), not null
#  post                    :boolean          default(TRUE), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  user_id                 :bigint
#
# Indexes
#
#  index_incoming_emails_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
