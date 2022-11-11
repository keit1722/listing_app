class Mypage::BookmarksController < Mypage::BaseController
  def index
    @bookmarks =
      current_user
      .bookmarks
      .includes(bookmarkable: [main_image_attachment: :blob])
      .page(params[:page])
      .per(20)
  end
end
