class HotSprings::PostsController < PostsController
  before_action :set_postable, only: [:index, :show]

  private

  def set_postable
    @postable = HotSpring.find_by(slug: params[:hot_spring_slug])
  end
end
