class Organizations::BaseController < ApplicationController
  before_action :only_business

  def set_districts
    @districts = District.all
  end

  def only_business
    unless current_user&.business?
      redirect_to root_path, error: 'ビジネスユーザー専用の機能です'
    end
  end
end
