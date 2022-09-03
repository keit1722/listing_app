class Organizations::OrganizationInvitationsController < Organizations::BaseController
  def index
    @organization =
      current_user.organizations.find_by!(slug: params[:organization_slug])
    @organization_invitations =
      @organization.organization_invitations.page(params[:page]).per(20).ordered
  end

  def new
    @organization_invitation =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .organization_invitations
      .build
  end

  def create
    @organization_invitation =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .organization_invitations
      .build(organization_invitation_params)

    if @organization_invitation.save
      @organization_invitation.create_notice

      redirect_to organization_organization_invitations_path,
                  success:
                    "#{@organization_invitation.email} に招待通知を送りました。承認されるまでお待ちください。"
    else
      flash.now[:error] = '招待できませんでした'
      render :new
    end
  end

  private

  def organization_invitation_params
    params
      .require(:organization_invitation)
      .permit(:email)
      .merge(
        organization: Organization.find_by(slug: params[:organization_slug]),
        inviter_id: current_user.id,
        expires_at: 6.hours.from_now
      )
  end
end
