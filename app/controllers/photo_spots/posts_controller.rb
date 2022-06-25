class PhotoSpots::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = PhotoSpot.find_by(slug: params[:photo_spot_slug])
  end
end
