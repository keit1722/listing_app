class PhotoSpots::SearchFormsController < ApplicationController
  def search
    @photo_spots =
      SearchForm
        .new(search_photo_spots_params)
        .search
        .with_attached_main_image
        .page(params[:page])
        .per(20)
    @photo_spots_count = SearchForm.new(search_photo_spots_params).search.count
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
