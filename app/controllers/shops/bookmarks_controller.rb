class Shops::BookmarksController < ApplicationController
  include Bookmarkable

  private

  def set_bookmarkable
    @bookmarkable = Shop.find_by(slug: params[:shop_slug])
  end
end
