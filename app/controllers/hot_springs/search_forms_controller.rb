class HotSprings::SearchFormsController < ApplicationController
  def search
    @hot_springs =
      SearchForm
      .new(search_hot_springs_params)
      .search
      .with_attached_main_image
      .page(params[:page])
      .per(20)
    @hot_springs_count = SearchForm.new(search_hot_springs_params).search.count
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_hot_springs_params
    params
      .fetch(:q, {})
      .permit(:keyword, area_groups: [])
      .merge(model: 'hot_spring')
  end
end
