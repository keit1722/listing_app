class Admin::BaseController < ApplicationController
  before_action :only_admin

  layout 'mypage'

  def only_admin
    if !current_user&.admin?
      redirect_to root_path, error: '管理者専用の機能です'
    end
  end
end
