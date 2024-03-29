class Pvsuwimvsuoitmucvyku::UsersController < Pvsuwimvsuoitmucvyku::BaseController
  def index
    @users = User.page(params[:page]).per(20)
  end

  def show
    @user = User.find_by!(public_uid: params[:public_uid])
  end

  def edit
    @user = User.find_by!(public_uid: params[:public_uid])
  end

  def update
    @user = User.find_by!(public_uid: params[:public_uid])
    if @user.update(user_params)
      redirect_to pvsuwimvsuoitmucvyku_user_path,
                  success: 'ユーザー情報を更新しました'
    else
      flash.now[:error] = 'ユーザー情報更新ができませんでした'
      render :edit
    end
  end

  def destroy
    @user = User.find_by!(public_uid: params[:public_uid])
    @user.destroy!
    redirect_to pvsuwimvsuoitmucvyku_users_path,
                success: 'ユーザーアカウントを削除しました'
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
        :role
      )
  end
end
