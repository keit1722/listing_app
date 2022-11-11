class Activities::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = Activity.find_by(slug: params[:activity_slug])
  end
end
