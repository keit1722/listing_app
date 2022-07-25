class Admin::OrganizationRegistrationStatusesController < Admin::BaseController
  def create
    @organization_registration_status =
      OrganizationRegistration.find(params[:organization_registration_id])
                              .build_organization_registration_status
    @organization_registration_status.status = params[:status]

    if @organization_registration_status.save
      organization_registration =
        @organization_registration_status.organization_registration
      user = organization_registration.user

      if @organization_registration_status.accepted?
        OrganizationRegistrationMailer
          .with(
            user_to: user,
            organization_registration: organization_registration
          )
          .accepted
          .deliver_later
        user.business! if user.general?
      elsif @organization_registration_status.rejected?
        OrganizationRegistrationMailer
          .with(
            user_to: user,
            organization_registration: organization_registration
          )
          .rejected
          .deliver_later
      end

      redirect_to admin_organization_registrations_path,
                  success: '申請の回答を作成しました'
    else
      redirect_to admin_organization_registrations_path,
                  error: '申請の回答を作成できませんでした'
    end
  end
end
