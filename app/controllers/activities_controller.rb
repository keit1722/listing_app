class ActivitiesController < ApplicationController
  def index
    @activities = Activity.with_attached_main_image.page(params[:page]).per(20)
    @activities_count = Activity.count
    render layout: 'listings_index'
  end

  def show
    @activity = Activity.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @activity.posts.with_attached_image.not_draft.recent(3)
    render layout: 'listings_single'
  end
end
