class HotSpringsController < ApplicationController
  def index
    @hot_springs = HotSpring.with_attached_images.page(params[:page]).per(20)
    @hot_springs_count = HotSpring.count
    render layout: 'listings_index'
  end

  def show
    @hot_spring = HotSpring.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @hot_spring.posts.with_attached_image.published.recent(3)
    render layout: 'listings_single'
  end

  def search
    @hot_springs =
      SearchForm
      .new(search_hot_springs_params)
      .search
      .with_attached_images
      .page(params[:page])
      .per(20)
    @hot_springs_count = SearchForm.new(search_hot_springs_params).search.count
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_hot_springs_params
    params
      .fetch(:q, {})
      .permit(:keyword, area_groups: [])
      .merge(model: 'hot_spring')
  end
end
