module AnnouncementAction
  extend ActiveSupport::Concern

  def publish
    @announcement =
      Announcement.new(
        announcement_params.merge(status: 'published', published_before: true),
      )
    if @announcement.save
      redirect_to pvsuwimvsuoitmucvyku_announcements_path, '投稿しました'
    else
      flash.now[:error] = '投稿できませんでした'
      render :new
    end
  end

  def unpublish
    @announcement = Announcement.new(announcement_params.merge(status: 'draft'))
    if @announcement.save
      redirect_to pvsuwimvsuoitmucvyku_announcements_path,
                  success: '下書きとして保存しました'
    else
      flash.now[:error] = '下書きとして保存できませんでした'
      render :new
    end
  end

  def to_published
    @announcement = Announcement.find(params[:id])
    if @announcement.update(
         announcement_params.merge(status: 'published', published_before: true),
       )
      redirect_to pvsuwimvsuoitmucvyku_announcement_path,
                  success: '投稿しました'
    else
      flash.now[:danger] = '投稿できませんでした'
      render :edit
    end
  end

  def to_draft
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params.merge(status: 'draft'))
      redirect_to pvsuwimvsuoitmucvyku_announcement_path,
                  success: '下書きとして変更しました'
    else
      flash.now[:danger] = '下書きとして変更できませんでした'
      render :edit
    end
  end

  def as_published
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
      redirect_to pvsuwimvsuoitmucvyku_announcement_path,
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end

  def as_draft
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
      redirect_to pvsuwimvsuoitmucvyku_announcement_path,
                  success: '内容を更新しました'
    else
      flash.now[:danger] = '内容を更新できませんでした'
      render :edit
    end
  end
end
