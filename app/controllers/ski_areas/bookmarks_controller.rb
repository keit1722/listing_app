class SkiAreas::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = SkiArea.find_by(slug: params[:ski_area_slug])
  end
end
