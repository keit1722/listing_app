class PhotoSpotsController < ApplicationController
  def index
    @photo_spots =
      PhotoSpot.with_attached_main_image.page(params[:page]).per(20)
    @photo_spots_count = PhotoSpot.count
    render layout: 'listings_index'
  end

  def show
    @photo_spot = PhotoSpot.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @photo_spot.posts.with_attached_image.not_draft.recent(3)
    render layout: 'listings_single'
  end
end
