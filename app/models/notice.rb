class Notice < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :noticeable, polymorphic: true

  validates :noticeable_id, uniqueness: { scope: [:noticeable_type, :user_id] }

  enum read: { unread: false, read: true }

  scope :ordered, -> { order(created_at: :desc) }

  def redirect_path
    case noticeable_type
    when 'Post'
      [noticeable.postable, noticeable]
    when 'OrganizationInvitation'
      organization_invitation_path(noticeable)
    when 'Organization'
      organization_path(noticeable)
    when 'Announcement'
      announcement_path(noticeable)
    end
  end
end

# == Schema Information
#
# Table name: notices
#
#  id              :bigint           not null, primary key
#  noticeable_type :string
#  read            :boolean          default("unread"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  noticeable_id   :bigint
#  user_id         :bigint
#
# Indexes
#
#  index_bookmarks_on_user_id_and_noticeable_id_and_type  (user_id,noticeable_id,noticeable_type) UNIQUE
#  index_notices_on_noticeable_type_and_noticeable_id     (noticeable_type,noticeable_id)
#  index_notices_on_user_id                               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
