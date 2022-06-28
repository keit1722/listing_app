class RestaurantsController < ApplicationController
  before_action :set_restaurant_categories, only: %i[index search]

  def index
    @restaurants =
      Restaurant
        .with_attached_images
        .includes(:restaurant_categories)
        .page(params[:page])
        .per(20)
    @restaurants_count = Restaurant.count
    render layout: 'listings_index'
  end

  def show
    @restaurant = Restaurant.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @restaurant.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end

  def search
    @restaurants =
      SearchWithCategoriesForm
        .new(search_restaurants_params)
        .search
        .with_attached_images
        .includes(:restaurant_categories, :restaurant_category_mappings)
        .page(params[:page])
        .per(20)
    @restaurants_count =
      SearchWithCategoriesForm.new(search_restaurants_params).search.count
    @selected_categories = params[:q][:category_ids]
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_restaurants_params
    params
      .fetch(:q, {})
      .permit(:keyword, category_ids: [], area_groups: [])
      .merge(model: 'restaurant')
  end

  def set_restaurant_categories
    @categories = RestaurantCategory.all
  end
end
