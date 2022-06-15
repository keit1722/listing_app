class SkiAreasController < ApplicationController
  def index
    @ski_areas = SkiArea.with_attached_images.page(params[:page]).per(20)
    @ski_area_all = SkiArea.all
    render layout: 'listings_index'
  end

  def show
    @ski_area = SkiArea.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
