class Admin::Organizations::Shops::PostsController < Admin::Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .find_by!(slug: params[:shop_slug])
  end
end
