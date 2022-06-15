class ActivitiesController < ApplicationController
  def show
    @activity = Activity.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
