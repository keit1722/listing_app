class Activities::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: %i[create destroy]

  private

  def set_bookmarkable
    @bookmarkable = Activity.find_by(slug: params[:activity_slug])
  end
end
