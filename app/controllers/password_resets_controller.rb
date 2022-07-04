class PasswordResetsController < ApplicationController
  def new; end

  def create
    @user = User.find_by(email: params[:email])

    @user.deliver_reset_password_instructions! if @user

    redirect_to root_path,
                success:
                  '登録メールアドレス宛にメールを送信しましたのでご確認ください'
  end

  def edit
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end
  end

  def update
    @token = params[:id]
    @user = User.load_from_reset_password_token(params[:id])

    if @user.blank?
      not_authenticated
      return
    end

    @user.password_confirmation = params[:user][:password_confirmation]

    if params[:user][:password].blank?
      flash.now[:error] = 'パスワードを入力してください'
      render :edit
      return
    end

    if @user.change_password(params[:user][:password])
      redirect_to root_path, success: 'パスワードが更新されました'
    else
      render :edit
    end
  end
end
