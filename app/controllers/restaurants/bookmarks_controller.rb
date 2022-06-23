class Restaurants::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: [:create, :destroy]

  private

  def set_bookmarkable
    @bookmarkable = Restaurant.find_by(slug: params[:restaurant_slug])
  end
end
