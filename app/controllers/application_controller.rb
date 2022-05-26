class ApplicationController < ActionController::Base
  add_flash_types :error, :success, :warning

  def not_authenticated
    redirect_to login_path, error: 'ログインしてください'
  end
end
