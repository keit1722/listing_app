class Hotels::SearchFormsController < ApplicationController
  def search
    @hotels =
      SearchForm
      .new(search_hotels_params)
      .search
      .with_attached_main_image
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
