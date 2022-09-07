class PostsController < ApplicationController
  def index
    @posts =
      @postable
        .posts
        .with_attached_image
        .published
        .page(params[:page])
        .per(5)
        .ordered
    @three_posts = @posts.limit(3)
  end

  def show
    @post = @postable.posts.published.find(params[:id])
    @posts = @postable.posts.with_attached_image.published.ordered
    @three_posts = @posts.limit(3)
  end
end
