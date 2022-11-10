module BookmarkableAssociation
  extend ActiveSupport::Concern

  included do
    has_many :bookmarks, as: :bookmarkable, dependent: :destroy
    has_many :users, through: :bookmarks
  end
end
