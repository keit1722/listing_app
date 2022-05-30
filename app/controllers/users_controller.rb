class UsersController < ApplicationController
  before_action :require_logout

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      auto_login(@user)
      redirect_to root_path, success: 'アカウントを作成しました'
    else
      flash.now[:error] = 'アカウントの作成ができませんでした'
      render :new
    end
  end

  private

  def user_params
    params
      .require(:user)
      .permit(
        :first_name,
        :last_name,
        :email,
        :password,
        :password_confirmation,
        :username
      )
  end
end
