class HotSpringsController < ApplicationController
  def index
    @hot_springs =
      HotSpring.with_attached_main_image.page(params[:page]).per(20)
    @hot_springs_count = HotSpring.count
    render layout: 'listings_index'
  end

  def show
    @hot_spring = HotSpring.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @hot_spring.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end
end
