class PhotoSpots::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = PhotoSpot.find_by(slug: params[:photo_spot_slug])
  end
end
