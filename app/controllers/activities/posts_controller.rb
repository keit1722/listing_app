class Activities::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = Activity.find_by(slug: params[:activity_slug])
  end
end
