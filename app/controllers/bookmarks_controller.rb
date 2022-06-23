class BookmarksController < ApplicationController
  def create
    current_user.bookmark(@bookmarkable)
    render 'listings/create'
  end

  def destroy
    current_user.unbookmark(@bookmarkable)
    render 'listings/destroy'
  end
end
