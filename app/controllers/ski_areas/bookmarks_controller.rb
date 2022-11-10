class SkiAreas::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = SkiArea.find_by(slug: params[:ski_area_slug])
  end
end
