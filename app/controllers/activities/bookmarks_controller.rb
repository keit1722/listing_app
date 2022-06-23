class Activities::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: [:create, :destroy]

  private

  def set_bookmarkable
    @bookmarkable = Activity.find_by(slug: params[:activity_slug])
  end
end
