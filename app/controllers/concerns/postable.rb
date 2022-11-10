module Postable
  extend ActiveSupport::Concern
  included { before_action :set_postable, only: %i[index show] }

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

  private

  def set_postable
    raise NotImplementedError, '@postableがsetされていません'
  end
end
