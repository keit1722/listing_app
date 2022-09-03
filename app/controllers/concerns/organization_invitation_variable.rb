module OrganizationInvitationVariable
  extend ActiveSupport::Concern

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
