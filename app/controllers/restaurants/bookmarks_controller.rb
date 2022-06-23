class Restaurants::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = Restaurant.find_by(slug: params[:restaurant_slug])
  end
end
