class PhotoSpotsController < ApplicationController
  def show
    @photo_spot = PhotoSpot.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
