class Mypage::IncomingEmailsController < Mypage::BaseController
  def show
    @incoming_email = current_user.incoming_email
  end

  def edit
    @incoming_email = current_user.incoming_email
  end

  def update
    @incoming_email = current_user.incoming_email
    if @incoming_email.update(incoming_email_params)
      redirect_to mypage_email_setting_path,
                  success: 'メールの受信設定を更新しました'
    else
      flash.now[:error] = 'メールの受信設定を更新できませんでした'
      render :edit
    end
  end

  private

  def incoming_email_params
    params
      .require(:incoming_email)
      .permit(:post, :announcement, :organization, :organization_invitation)
  end
end
