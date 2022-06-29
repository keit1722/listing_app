class ShopsController < ApplicationController
  before_action :set_shop_categories, only: [:index, :search]

  def index
    @shops =
      Shop
      .with_attached_images
      .includes(:shop_categories)
      .page(params[:page])
      .per(20)
    @shops_count = Shop.count
    render layout: 'listings_index'
  end

  def show
    @shop = Shop.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @shop.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end

  def search
    @shops =
      SearchWithCategoriesForm
      .new(search_shops_params)
      .search
      .with_attached_images
      .includes(:shop_categories, :shop_category_mappings)
      .page(params[:page])
      .per(20)
    @shops_count =
      SearchWithCategoriesForm.new(search_shops_params).search.count
    @selected_categories = params[:q][:category_ids]
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_shops_params
    params
      .fetch(:q, {})
      .permit(:keyword, category_ids: [], area_groups: [])
      .merge(model: 'shop')
  end

  def set_shop_categories
    @categories = ShopCategory.all
  end
end
