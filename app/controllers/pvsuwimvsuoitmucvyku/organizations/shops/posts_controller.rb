class Pvsuwimvsuoitmucvyku::Organizations::Shops::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .find_by!(slug: params[:shop_slug])
  end
end
