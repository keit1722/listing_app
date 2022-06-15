class SkiAreasController < ApplicationController
  def show
    @ski_area = SkiArea.with_attached_images.find_by!(slug: params[:slug])
    render layout: 'listings_single'
  end
end
