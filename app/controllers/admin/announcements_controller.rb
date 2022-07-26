class Admin::AnnouncementsController < Admin::BaseController
  def index
    @announcements =
      Announcement.with_attached_image.page(params[:page]).per(20).ordered
  end

  def show
    @announcement = Announcement.find(params[:id])
  end

  def new
    @announcement = Announcement.new
  end

  def create
    @announcement = Announcement.new(announcement_params)
    if @announcement.save
      redirect_to admin_announcements_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def update
    @announcement = Announcement.find(params[:id])
    if @announcement.update(announcement_params)
      redirect_to admin_announcement_path, success: '更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy!
    redirect_to admin_announcements_path, success: '削除しました'
  end

  private

  def announcement_params
    params
      .require(:announcement)
      .permit(:title, :body, :status)
      .merge(poster_id: current_user.id)
  end
end
