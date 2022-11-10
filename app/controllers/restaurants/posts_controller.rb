class Restaurants::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = Restaurant.find_by(slug: params[:restaurant_slug])
  end
end
