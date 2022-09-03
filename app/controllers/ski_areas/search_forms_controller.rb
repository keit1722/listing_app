class SkiAreas::SearchFormsController < ApplicationController
  def search
    @ski_areas =
      SearchForm
      .new(search_ski_areas_params)
      .search
      .with_attached_main_image
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
