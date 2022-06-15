class HotSpringsController < ApplicationController
  def show
    @hot_spring = HotSpring.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
