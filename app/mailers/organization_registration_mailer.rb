class OrganizationRegistrationMailer < ApplicationMailer
  def accepted
    @user_to = params[:user_to]
    @organization_registration = params[:organization_registration]

    mail(
      to: @user_to.email,
      subject:
        "#{@organization_registration.organization_name} の登録申請が承認されました",
    )
  end

  def rejected
    @user_to = params[:user_to]
    @organization_registration = params[:organization_registration]

    mail(
      to: @user_to.email,
      subject:
        "#{@organization_registration.organization_name} の登録申請が否認されました",
    )
  end
end
