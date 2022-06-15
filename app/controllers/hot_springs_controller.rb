class HotSpringsController < ApplicationController
  def index
    @hot_springs = HotSpring.with_attached_images.page(params[:page]).per(20)
    @hot_spring_all = HotSpring.all
    render layout: 'listings_index'
  end

  def show
    @hot_spring = HotSpring.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
