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
end
