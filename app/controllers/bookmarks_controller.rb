class BookmarksController < ApplicationController
  before_action :require_login

  def create
    current_user.bookmark(@bookmarkable)
    render 'listings/bookmarks/create'
  end

  def destroy
    current_user.unbookmark(@bookmarkable)
    render 'listings/bookmarks/destroy'
  end
end
