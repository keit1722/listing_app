class Pvsuwimvsuoitmucvyku::SessionsController < Pvsuwimvsuoitmucvyku::BaseController
  layout 'application', only: :new

  skip_before_action :only_admin, only: [:new, :create]
  before_action :require_logout, only: [:new, :create]

  def new; end

  def create
    unless User.find_by(email: params[:email].downcase)&.admin?
      flash.now[:error] =
        'ログインできませんでした。メールアドレスまたはパスワードを確認してください。'
      render :new and return
    end

    @user = login(params[:email].downcase, params[:password])
    if @user
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:error] =
        'ログインできませんでした。メールアドレスまたはパスワードを確認してください。'
      render :new
    end
  end
end
