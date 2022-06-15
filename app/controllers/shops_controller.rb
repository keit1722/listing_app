class ShopsController < ApplicationController
  def show
    @shop = Shop.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
