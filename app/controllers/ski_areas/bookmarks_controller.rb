class SkiAreas::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: [:create, :destroy]

  private

  def set_bookmarkable
    @bookmarkable = SkiArea.find_by(slug: params[:ski_area_slug])
  end
end
