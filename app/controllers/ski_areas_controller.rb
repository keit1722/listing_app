class SkiAreasController < ApplicationController
  def index
    @ski_areas = SkiArea.with_attached_images.page(params[:page]).per(20)
    @ski_areas_count = SkiArea.count
    render layout: 'listings_index'
  end

  def show
    @ski_area = SkiArea.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @ski_area.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end

  def search
    @ski_areas =
      SearchForm
        .new(search_ski_areas_params)
        .search
        .with_attached_images
        .page(params[:page])
        .per(20)
    @ski_areas_count = SearchForm.new(search_ski_areas_params).search.count
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_ski_areas_params
    params
      .fetch(:q, {})
      .permit(:keyword, area_groups: [])
      .merge(model: 'ski_area')
  end
end
