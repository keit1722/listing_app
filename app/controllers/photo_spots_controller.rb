class PhotoSpotsController < ApplicationController
  def index
    @photo_spots = PhotoSpot.with_attached_images.page(params[:page]).per(20)
    @photo_spot_all = PhotoSpot.all
    render layout: 'listings_index'
  end

  def show
    @photo_spot = PhotoSpot.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
