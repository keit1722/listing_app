class ApplicationController < ActionController::Base
  add_flash_types :error, :success, :warning

  def not_authenticated
    redirect_to login_path, error: 'ログインしてください'
  end

  def require_logout
    redirect_to root_path, error: 'ログアウトしてください' if logged_in?
  end

  def only_business_or_admin
    if !current_user&.business? && !current_user&.admin?
      redirect_to root_path, error: 'ビジネスユーザー専用の機能です'
    end
  end
end
