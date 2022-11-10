class Hotels::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = Hotel.find_by(slug: params[:hotel_slug])
  end
end
