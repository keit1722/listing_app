class Admin::Organizations::PhotoSpots::PostsController < Admin::Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .find_by!(slug: params[:photo_spot_slug])
  end
end
