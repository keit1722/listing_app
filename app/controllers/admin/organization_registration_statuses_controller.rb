class Admin::OrganizationRegistrationStatusesController < ApplicationController
  layout 'mypage'

  def index
    @organization_registration_statuses = OrganizationRegistrationStatus.all
  end

  def new
    @organization_registration_status = OrganizationRegistrationStatus.new
  end

  def create
    @organization_registration_status =
      OrganizationRegistrationStatus.new(
        organization_registration_status_params,
      )
    if @organization_registration_status.save
      redirect_to organization_registration_status_path,
                  success: '申請の回答を作成しました'
    else
      flash.now[:error] = '申請の回答を作成できませんでした'
      render :new
    end
  end

  def show
    @organization_registration_status =
      OrganizationRegistrationStatus.find(params[:id])
  end

  private

  def organization_registration_status_params
    params.require(:organization_registration_status).permit(:status)
  end
end
