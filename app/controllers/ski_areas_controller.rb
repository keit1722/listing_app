class SkiAreasController < ApplicationController
  def index
    @ski_areas = SkiArea.with_attached_main_image.page(params[:page]).per(20)
    @ski_areas_count = SkiArea.count
    render layout: 'listings_index'
  end

  def show
    @ski_area = SkiArea.with_attached_images.find_by!(slug: params[:slug])
    @three_posts = @ski_area.posts.with_attached_image.not_draft.recent(3)
    render layout: 'listings_single'
  end
end
