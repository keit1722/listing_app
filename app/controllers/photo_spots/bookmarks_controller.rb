class PhotoSpots::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = PhotoSpot.find_by(slug: params[:photo_spot_slug])
  end
end
