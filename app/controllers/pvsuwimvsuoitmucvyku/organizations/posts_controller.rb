class Pvsuwimvsuoitmucvyku::Organizations::PostsController < Pvsuwimvsuoitmucvyku::BaseController
  include AdminPostAction

  def index
    @posts =
      @postable.posts.with_attached_image.page(params[:page]).per(20).ordered
  end

  def show
    @post = @postable.posts.find(params[:id])
  end

  def edit
    @post = @postable.posts.find(params[:id])
  end

  def destroy
    @post = @postable.posts.find(params[:id])
    @post.destroy!
    redirect_to [
                  :pvsuwimvsuoitmucvyku,
                  @postable.organization,
                  @postable,
                  :posts,
                ],
                success: '削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :image)
  end
end
