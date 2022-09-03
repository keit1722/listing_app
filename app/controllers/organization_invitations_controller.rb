class OrganizationInvitationsController < ApplicationController
  layout 'mypage'

  include OrganizationInvitationVariable
  before_action :check_valid_action, only: [:show]

  def show; end
end
