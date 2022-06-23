class Organizations::Shops::PostsController < Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .shops
        .find_by!(slug: params[:shop_slug])
  end
end
