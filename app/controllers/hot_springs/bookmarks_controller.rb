class HotSprings::BookmarksController < BookmarksController
  before_action :set_bookmarkable, only: [:create, :destroy]

  private

  def set_bookmarkable
    @bookmarkable = HotSpring.find_by(slug: params[:hot_spring_slug])
  end
end
