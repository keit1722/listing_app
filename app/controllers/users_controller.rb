class UsersController < ApplicationController
  before_action :require_logout, only: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to root_path,
                  success:
                    'メールアドレスに確認メールを送信しました。メール内のリンクをクリックしてアカウントを有効化してください。'
    else
      flash.now[:error] = 'アカウントの作成ができませんでした'
      render :new
    end
  end

  def activate
    if (@user = User.load_from_activation_token(params[:id]))
      @user.activate!
      auto_login(@user)
      redirect_to root_path, success: 'アカウントが有効になりました'
    else
      not_authenticated
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
