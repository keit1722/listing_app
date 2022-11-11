class HotSprings::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = HotSpring.find_by(slug: params[:hot_spring_slug])
  end
end
