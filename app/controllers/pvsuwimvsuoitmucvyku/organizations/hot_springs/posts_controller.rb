class Pvsuwimvsuoitmucvyku::Organizations::HotSprings::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hot_springs
        .find_by!(slug: params[:hot_spring_slug])
  end
end
