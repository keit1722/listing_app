class Admin::Organizations::Restaurants::PostsController < Admin::Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .find_by!(slug: params[:restaurant_slug])
  end
end
