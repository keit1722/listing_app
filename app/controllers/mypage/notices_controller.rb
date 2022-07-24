class Mypage::NoticesController < Mypage::BaseController
  layout 'mypage', only: [:index]

  def index
    @notices =
      current_user
        .notices
        .includes([noticeable: [:postable]])
        .page(params[:page])
        .per(20)
        .ordered
  end
end
