class Organizations::OrganizationInvitationsController < ApplicationController
  layout 'mypage', only: %i[index new create]

  def index
    @organization_invitations =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .organization_invitations
        .page(params[:page])
        .per(20)
        .ordered
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
      if @organization_invitation.find_invitee(@organization_invitation.email)
        @organization_invitation.create_notice
      end

      redirect_to organization_organization_invitations_path,
                  success:
                    "#{@organization_invitation.email} さんに招待通知を送りました。承認されるまでお待ちください。"
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
        expires_at: Time.current + 6.hours,
      )
  end
end
