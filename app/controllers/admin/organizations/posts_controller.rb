class Admin::Organizations::PostsController < Admin::BaseController
  layout 'mypage'

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

  def update
    @post = @postable.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to [:admin, @postable.organization, @postable, @post],
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end

  def destroy
    @post = @postable.posts.find(params[:id])
    @post.destroy!
    redirect_to [:admin, @postable.organization, @postable, :posts],
                success: '削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :status, :image)
  end
end
