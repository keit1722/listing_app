class PhotoSpotsController < ApplicationController
  def index
    @photo_spots = PhotoSpot.with_attached_images.page(params[:page]).per(20)
    @photo_spot_all = PhotoSpot.all
    render layout: 'listings_index'
  end

  def show
    @photo_spot = PhotoSpot.with_attached_images.find_by!(slug: params[:slug])
    @three_posts =
      @photo_spot.posts.with_attached_image.published.recent.first(3)
    render layout: 'listings_single'
  end

  def search
    @photo_spots =
      SearchForm
        .new(search_photo_spots_params)
        .search
        .with_attached_images
        .page(params[:page])
        .per(20)
    @photo_spot_all = SearchForm.new(search_photo_spots_params).search
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_photo_spots_params
    params
      .fetch(:q, {})
      .permit(:keyword, area_groups: [])
      .merge(model: 'photo_spot')
  end
end
