class PhotoSpots::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: [:create, :destroy]

  private

  def set_bookmarkable
    @bookmarkable = PhotoSpot.find_by(slug: params[:photo_spot_slug])
  end
end
