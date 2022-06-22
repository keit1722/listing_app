class ActivitiesController < ApplicationController
  def index
    @activities = Activity.with_attached_images.page(params[:page]).per(20)
    @activity_all = Activity.all
    render layout: 'listings_index'
  end

  def show
    @activity = Activity.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end

  def search
    @activities =
      SearchForm
      .new(search_activities_params)
      .search
      .with_attached_images
      .page(params[:page])
      .per(20)
    @activity_all = SearchForm.new(search_activities_params).search
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
