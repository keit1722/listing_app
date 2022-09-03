class OrganizationInvitations::ActionsController < ApplicationController
  layout 'mypage'

  include OrganizationInvitationVariable
  before_action :check_valid_action, only: [:accepted, :unaccepted]

  def accepted
    @organization_invitation.accepted!
    current_user.business! if current_user.general?
    @organization_invitation.organization.create_notices
    @organization_invitation.organization.users << current_user
    redirect_to mypage_notices_path, success: '組織へ参加しました'
  end

  def unaccepted
    @organization_invitation.rejected!
    redirect_to mypage_notices_path, success: '組織へ参加しませんでした'
  end
end
