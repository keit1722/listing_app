class Organizations::BaseController < ApplicationController
  before_action :only_business_or_admin

  layout 'mypage'
end
