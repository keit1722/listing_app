class Hotels::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = Hotel.find_by(slug: params[:hotel_slug])
  end
end
