module AdminPostAction
  extend ActiveSupport::Concern

  def to_published
    @post = @postable.posts.find(params[:id])
    if @post.update(
      post_params.merge(status: 'published', published_before: true)
    )
      @post.create_notices('新しく投稿をしました')
      redirect_to [
        :pvsuwimvsuoitmucvyku,
        @postable.organization,
        @postable,
        @post
      ],
                  success: '投稿しました'
    else
      flash.now[:danger] = '投稿できませんでした'
      render :edit
    end
  end

  def to_draft
    @post = @postable.posts.find(params[:id])
    if @post.update(post_params.merge(status: 'draft'))
      redirect_to [
        :pvsuwimvsuoitmucvyku,
        @postable.organization,
        @postable,
        @post
      ],
                  success: '下書きとして変更しました'
    else
      flash.now[:danger] = '下書きとして変更できませんでした'
      render :edit
    end
  end

  def as_published
    @post = @postable.posts.find(params[:id])
    if @post.update(post_params)
      @post.create_notices('投稿内容を更新しました')
      redirect_to [
        :pvsuwimvsuoitmucvyku,
        @postable.organization,
        @postable,
        @post
      ],
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end

  def as_draft
    @post = @postable.posts.find(params[:id])
    if @post.update(post_params)
      redirect_to [
        :pvsuwimvsuoitmucvyku,
        @postable.organization,
        @postable,
        @post
      ],
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end
end
