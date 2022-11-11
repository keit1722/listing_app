class SkiAreas::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = SkiArea.find_by(slug: params[:ski_area_slug])
  end
end
