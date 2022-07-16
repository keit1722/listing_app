class Admin::OrganizationRegistrationStatusesController < ApplicationController
  layout 'mypage'

  def create
    @organization_registration_status =
      OrganizationRegistration.find(params[:organization_registration_id])
        .build_organization_registration_status
    user = @organization_registration_status.organization_registration.user
    @organization_registration_status.status = params[:status] && user.general?
    if @organization_registration_status.accepted? && user.business!
      user.business!
    end

    if @organization_registration_status.save
      redirect_to admin_organization_registrations_path,
                  success: '申請の回答を作成しました'
    else
      redirect_to admin_organization_registrations_path,
                  error: '申請の回答を作成できませんでした'
    end
  end
end
