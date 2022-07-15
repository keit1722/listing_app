class NoticeMailer < ApplicationMailer
  def post
    @user_to = params[:user_to]
    @post = params[:post]

    mail(
      to: @user_to.email,
      subject: "#{@post.postable.name} が新しく投稿をしました"
    )
  end

  def organization_invitation
    @user_to = params[:user_to]
    @organization_invitation = params[:organization_invitation]

    mail(
      to: @user_to.email,
      subject:
        "#{@organization_invitation.organization.name} がへの招待が届いています"
    )
  end

  def organization
    @user_to = params[:user_to]
    @organization = params[:organization]

    mail(
      to: @user_to.email,
      subject: "#{@organization.name} にユーザーが参加しました"
    )
  end
end
