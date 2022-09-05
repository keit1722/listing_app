class PostsController < ApplicationController
  def index
    @posts =
      @postable
        .posts
        .with_attached_image
        .not_draft
        .page(params[:page])
        .per(5)
        .ordered
    @three_posts = @posts.limit(3)
  end

  def show
    @post = @postable.posts.not_draft.find(params[:id])
    @posts = @postable.posts.with_attached_image.not_draft.ordered
    @three_posts = @posts.limit(3)
  end
end
