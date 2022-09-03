class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :bookmarkable, polymorphic: true

  validates :bookmarkable_id,
            uniqueness: {
              scope: [:bookmarkable_type, :user_id]
            }
end

# == Schema Information
#
# Table name: bookmarks
#
#  id                :bigint           not null, primary key
#  bookmarkable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  bookmarkable_id   :bigint
#  user_id           :bigint
#
# Indexes
#
#  index_bookmarks_on_bookmarkable_type_and_bookmarkable_id  (bookmarkable_type,bookmarkable_id)
#  index_bookmarks_on_user_id                                (user_id)
#  index_bookmarks_on_user_id_and_bookmarkable_id_and_type   (user_id,bookmarkable_id,bookmarkable_type) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
