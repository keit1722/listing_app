class Activities::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = Activity.find_by(slug: params[:activity_slug])
  end
end
