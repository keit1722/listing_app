class OrganizationInvitationsController < ApplicationController
  layout 'mypage', only: %i[show]

  before_action :check_valid_action, only: %i[show accepted unaccepted]

  def show; end

  def accepted
    @organization_invitation.accepted!
    current_user.business! if current_user.general?
    @organization_invitation.organization.users << current_user
    redirect_to mypage_notices_path, success: '組織へ参加しました'
  end

  def unaccepted
    @organization_invitation.rejected!
    redirect_to mypage_notices_path, success: '組織へ参加しませんでした'
  end

  private

  def check_valid_action
    @organization_invitation =
      OrganizationInvitation.find_by!(token: params[:token])

    if current_user != @organization_invitation.notices.first.user ||
         Time.current > @organization_invitation.expires_at ||
         !@organization_invitation.untouched? ||
         @organization_invitation.organization.users.include?(current_user)
      redirect_to mypage_notices_path, error: '無効なリンクです' and return
    end
  end
end
