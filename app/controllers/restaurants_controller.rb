class RestaurantsController < ApplicationController
  def index
    @restaurants =
      Restaurant
        .with_attached_images
        .includes(:restaurant_categories)
        .page(params[:page])
        .per(20)
    @restaurant_all = Restaurant.all
    render layout: 'listings_index'
  end

  def show
    @restaurant = Restaurant.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
