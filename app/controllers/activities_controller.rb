class ActivitiesController < ApplicationController
  def index
    @activities = Activity.with_attached_images.page(params[:page]).per(20)
    @activities_count = Activity.count
    render layout: 'listings_index'
  end

  def show
    @activity = Activity.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @activity.posts.with_attached_image.published.recent(3)
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
