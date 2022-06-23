class Hotels::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = Hotel.find_by(slug: params[:hotel_slug])
  end
end
