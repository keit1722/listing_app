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
    @announcement = Announcement.with_attached_image.published.ordered
  end
end
