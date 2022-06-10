class Organizations::BaseController < ApplicationController
  def determine_mypage_layout
    action_name == 'index' ? 'mypage' : 'mypage_maps'
  end

  def set_districts
    @districts = District.all
  end
end
