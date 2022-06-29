class Mypage::BookmarksController < ApplicationController
  layout 'mypage'

  def index
    @bookmarks =
      current_user.bookmarks.includes(:bookmarkable).page(params[:page]).per(20)
  end
end
