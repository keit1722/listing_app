class Organizations::PhotoSpots::PostsController < Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .photo_spots
      .find_by!(slug: params[:photo_spot_slug])
  end
end
