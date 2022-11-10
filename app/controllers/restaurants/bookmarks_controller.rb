class Restaurants::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = Restaurant.find_by(slug: params[:restaurant_slug])
  end
end
