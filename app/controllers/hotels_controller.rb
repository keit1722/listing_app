class HotelsController < ApplicationController
  def show
    @hotel = Hotel.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
