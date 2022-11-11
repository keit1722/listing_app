module Bookmarkable
  extend ActiveSupport::Concern
  included { before_action :set_bookmarkable, only: [:create, :destroy] }

  def create
    current_user.bookmark(@bookmarkable)
    render 'listings/bookmarks/create'
  end

  def destroy
    current_user.unbookmark(@bookmarkable)
    render 'listings/bookmarks/destroy'
  end

  private

  def set_bookmarkable
    raise NotImplementedError, '@bookmarkableがsetされていません'
  end
end
