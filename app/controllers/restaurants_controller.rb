class RestaurantsController < ApplicationController
  def show
    @restaurant = Restaurant.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
