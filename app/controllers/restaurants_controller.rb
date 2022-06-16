class RestaurantsController < ApplicationController
  before_action :set_restaurant_categories, only: %i[index search]

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

  def search
    @restaurants =
      SearchRestaurantsForm
        .new(search_restaurants_params)
        .search
        .with_attached_images
        .includes(:restaurant_categories, :restaurant_category_mappings)
        .page(params[:page])
        .per(20)
    @restaurant_all =
      SearchRestaurantsForm.new(search_restaurants_params).search
    render layout: 'listings_index'
  end

  private

  def search_restaurants_params
    params.fetch(:q, {}).permit(:keyword, category_ids: [])
  end

  def set_restaurant_categories
    @restaurant_categories = RestaurantCategory.all
  end
end
