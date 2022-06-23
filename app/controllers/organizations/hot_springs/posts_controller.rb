class Organizations::HotSprings::PostsController < Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hot_springs
        .find_by!(slug: params[:hot_spring_slug])
  end
end
