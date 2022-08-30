class HotelsController < ApplicationController
  def index
    @hotels = Hotel.with_attached_main_image.page(params[:page]).per(20)
    @hotels_count = Hotel.count
    render layout: 'listings_index'
  end

  def show
    @hotel = Hotel.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @hotel.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end
end
