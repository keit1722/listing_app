class HotelsController < ApplicationController
  def index
    @hotels = Hotel.with_attached_images.page(params[:page]).per(20)
    @hotel_all = Hotel.all
    render layout: 'listings_index'
  end

  def show
    @hotel = Hotel.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
