class RestaurantsController < ApplicationController
  def index
    @restaurants =
      Restaurant
        .with_attached_main_image
        .includes(:restaurant_categories)
        .page(params[:page])
        .per(20)
    @categories = RestaurantCategory.all
    @restaurants_count = Restaurant.count
    render layout: 'listings_index'
  end

  def show
    @restaurant = Restaurant.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @restaurant.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end
end
