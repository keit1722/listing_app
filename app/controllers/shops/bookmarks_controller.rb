class Shops::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = Shop.find_by(slug: params[:shop_slug])
  end
end
