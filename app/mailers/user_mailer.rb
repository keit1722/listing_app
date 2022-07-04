class UserMailer < ApplicationMailer
  def activation_needed_email(user)
    @user = user
    @url = activate_user_url(user.activation_token)
    mail(to: user.email, subject: 'メールアドレス確認メール')
  end

  def activation_success_email(user)
    @user = user
    mail(to: user.email, subject: 'アカウント有効化完了')
  end

  def reset_password_email(user)
    @user = User.find(user.id)
    @url = edit_password_reset_url(@user.reset_password_token)
    mail(to: user.email, subject: 'パスワード再設定メール')
  end
end
