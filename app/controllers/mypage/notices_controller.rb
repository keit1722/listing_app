class Mypage::NoticesController < Mypage::BaseController
  def index
    notices = current_user.notices.includes([:noticeable])
    preloader = ActiveRecord::Associations::Preloader.new
    preloader.preload(
      notices.select { |notice| notice.noticeable_type == 'Post' },
      noticeable: [:postable],
    )
    @notices = notices.page(params[:page]).per(20).ordered
  end
end
