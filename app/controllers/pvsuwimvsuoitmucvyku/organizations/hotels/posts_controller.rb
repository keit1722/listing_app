class Pvsuwimvsuoitmucvyku::Organizations::Hotels::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .find_by!(slug: params[:hotel_slug])
  end
end
