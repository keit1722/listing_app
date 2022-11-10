class HotSprings::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = HotSpring.find_by(slug: params[:hot_spring_slug])
  end
end
