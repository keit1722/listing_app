class Organizations::BaseController < ApplicationController
  before_action :only_business_or_admin

  def set_districts
    @districts = District.all
  end
end
