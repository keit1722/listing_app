class BookmarksController < ApplicationController
  def create
    current_user.bookmark(@bookmarkable)
    render 'listings/create.js.erb'
  end

  def destroy
    current_user.unbookmark(@bookmarkable)
    render 'listings/destroy.js.erb'
  end
end
