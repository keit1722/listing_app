class NoticesController < ApplicationController
  before_action :require_login, only: [:read]

  def read
    notice = current_user.notices.find(params[:id])
    notice.read! if notice.unread?
    redirect_to notice.redirect_path
  end
end
