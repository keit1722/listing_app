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

  def search
    @hotels =
      SearchForm
      .new(search_hotels_params)
      .search
      .with_attached_images
      .page(params[:page])
      .per(20)
    @hotel_all = SearchForm.new(search_hotels_params).search
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_hotels_params
    params.fetch(:q, {}).permit(:keyword, area_groups: []).merge(model: 'hotel')
  end
end
