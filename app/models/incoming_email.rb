class IncomingEmail < ApplicationRecord
  belongs_to :user
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
