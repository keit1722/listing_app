class PostsController < ApplicationController
  def index
    @posts =
      @postable
      .posts
      .with_attached_image
      .published
      .page(params[:page])
      .per(5)
      .recent
    @three_posts = @posts.first(3)
  end

  def show
    @post = @postable.posts.published.find(params[:id])
    @posts = @postable.posts.with_attached_image.published.recent
    @three_posts = @posts.first(3)
  end
end
