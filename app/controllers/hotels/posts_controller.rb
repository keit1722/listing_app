class Hotels::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = Hotel.find_by(slug: params[:hotel_slug])
  end
end
