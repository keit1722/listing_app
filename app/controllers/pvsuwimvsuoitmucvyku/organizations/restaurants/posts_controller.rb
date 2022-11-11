class Pvsuwimvsuoitmucvyku::Organizations::Restaurants::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostable

  private

  def set_postable
    @postable =
      Organization
      .find_by!(slug: params[:organization_slug])
      .restaurants
      .find_by!(slug: params[:restaurant_slug])
  end
end
