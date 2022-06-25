class Restaurants::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = Restaurant.find_by(slug: params[:restaurant_slug])
  end
end
