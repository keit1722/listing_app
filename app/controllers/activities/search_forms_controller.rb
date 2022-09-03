class Activities::SearchFormsController < ApplicationController
  def search
    @activities =
      SearchForm
      .new(search_activities_params)
      .search
      .with_attached_main_image
      .page(params[:page])
      .per(20)
    @activities_count = SearchForm.new(search_activities_params).search.count
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_activities_params
    params
      .fetch(:q, {})
      .permit(:keyword, area_groups: [])
      .merge(model: 'activity')
  end
end
