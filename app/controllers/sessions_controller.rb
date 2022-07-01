class SessionsController < ApplicationController
  before_action :require_login, only: [:destroy]
  before_action :require_logout, only: %i[new create]

  def new; end

  def create
    @user = login(params[:email].downcase, params[:password])
    if @user
      redirect_back_or_to root_path, success: 'ログインしました'
    else
      flash.now[:error] =
        'ログインできませんでした。メールアドレスまたはパスワードを確認してください。'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: 'ログアウトしました'
  end
end
