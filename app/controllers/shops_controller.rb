class ShopsController < ApplicationController
  def index
    @shops =
      Shop
        .with_attached_main_image
        .includes(:shop_categories)
        .page(params[:page])
        .per(20)
    @categories = ShopCategory.all
    @shops_count = Shop.count
    render layout: 'listings_index'
  end

  def show
    @shop = Shop.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @shop.posts.with_attached_image.not_draft.recent(3)
    render layout: 'listings_single'
  end
end
