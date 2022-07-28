class AnnouncementsController < ApplicationController
  def index
    @announcements =
      Announcement
        .with_attached_image
        .published
        .page(params[:page])
        .per(5)
        .ordered
  end

  def show
    @announcement = Announcement.published.find(params[:id])
    @announcements = Announcement.with_attached_image.published.recent(3)
  end
end
