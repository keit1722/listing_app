class Organizations::PostsController < ApplicationController
  layout 'mypage'

  def index
    @posts =
      @postable.posts.with_attached_image.page(params[:page]).per(20).ordered
  end

  def show
    @post = @postable.posts.find(params[:id])
  end

  def new
    @post = @postable.posts.build
  end

  def create
    @post = @postable.posts.build(post_params)
    if @post.save
      redirect_to [@postable.organization, @postable, :posts],
                  success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @post = @postable.posts.find(params[:id])
  end

  def update
    @post = @postable.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to [@postable.organization, @postable, @post],
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end

  def destroy
    @post = @postable.posts.find(params[:id])
    @post.destroy!
    redirect_to [@postable.organization, @postable, :posts],
                success: '削除しました'
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :status, :image)
  end
end
