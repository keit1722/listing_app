class Pvsuwimvsuoitmucvyku::AnnouncementsController < Pvsuwimvsuoitmucvyku::BaseController
  include AnnouncementAction

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

  def edit
    @announcement = Announcement.find(params[:id])
  end

  def destroy
    @announcement = Announcement.find(params[:id])
    @announcement.destroy!
    redirect_to pvsuwimvsuoitmucvyku_announcements_path, success: '削除しました'
  end

  private

  def announcement_params
    params
      .require(:announcement)
      .permit(:title, :body :image)
      .merge(poster_id: current_user.id)
  end
end
