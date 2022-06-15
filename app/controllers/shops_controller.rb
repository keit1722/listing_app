class ShopsController < ApplicationController
  def index
    @shops =
      Shop
        .with_attached_images
        .includes(:shop_categories)
        .page(params[:page])
        .per(20)
    @shop_all = Shop.all
    render layout: 'listings_index'
  end

  def show
    @shop = Shop.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
