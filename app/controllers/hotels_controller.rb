class HotelsController < ApplicationController
  def index
    @hotels = Hotel.with_attached_images.page(params[:page]).per(20)
    @hotels_count = Hotel.count
    render layout: 'listings_index'
  end

  def show
    @hotel = Hotel.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @hotel.posts.with_attached_image.published.recent.first(3)
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
    @hotels_count = SearchForm.new(search_hotels_params).search.count
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_hotels_params
    params.fetch(:q, {}).permit(:keyword, area_groups: []).merge(model: 'hotel')
  end
end
