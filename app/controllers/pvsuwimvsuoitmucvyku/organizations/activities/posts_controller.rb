class Pvsuwimvsuoitmucvyku::Organizations::Activities::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .find_by!(slug: params[:activity_slug])
  end
end
