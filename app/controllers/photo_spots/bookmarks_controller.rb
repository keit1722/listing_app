class PhotoSpots::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = PhotoSpot.find_by(slug: params[:photo_spot_slug])
  end
end
