class Shops::PostsController < PostsController
  before_action :set_postable, only: %i[index show]

  private

  def set_postable
    @postable = Shop.find_by(slug: params[:shop_slug])
  end
end
