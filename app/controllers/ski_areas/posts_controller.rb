class SkiAreas::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = SkiArea.find_by(slug: params[:ski_area_slug])
  end
end
