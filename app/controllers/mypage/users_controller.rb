class Mypage::UsersController < Mypage::BaseController
  def show
    @user = User.find_by(public_uid: current_user.public_uid)
  end

  def edit
    @user = User.find_by(public_uid: current_user.public_uid)
  end

  def update
    @user = User.find_by(public_uid: current_user.public_uid)
    if @user.update(user_params)
      redirect_to mypage_profile_path, success: 'プロフィールを更新しました'
    else
      flash.now[:error] = 'プロフィール更新ができませんでした'
      render :edit
    end
  end

  def destroy
    @user = User.find_by(public_uid: current_user.public_uid)
    @user.destroy!
    redirect_to root_path, success: 'アカウントを削除しました'
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
        :username,
      )
  end
end
