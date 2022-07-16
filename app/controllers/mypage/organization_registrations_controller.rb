class Mypage::OrganizationRegistrationsController < ApplicationController
  layout 'mypage'

  def index
    @organization_registrations = current_user.organization_registrations
  end

  def new
    @organization_registration = current_user.organization_registrations.build
  end

  def create
    @organization_registration =
      current_user.organization_registrations.build(
        organization_registration_params,
      )
    if @organization_registration.save
      redirect_to organization_registration_path,
                  success: '組織登録の申請をしました'
    else
      flash.now[:error] = '組織登録の申請ができませんでした'
      render :new
    end
  end

  def show
    @organization_registration =
      current_user.organization_registrations.find(params[:id])
  end

  private

  def organization_registration_params
    params
      .require(:organization_registration)
      .permit(
        :organization_name,
        :organization_address,
        :organization_phone,
        :business_detail,
      )
  end
end
