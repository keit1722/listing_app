class Admin::OrganizationRegistrationsController < ApplicationController
  layout 'mypage'

  def index
    @organization_registrations =
      OrganizationRegistration
        .includes(:organization_registration_status)
        .page(params[:page])
        .per(20)
        .ordered
  end

  def show
    @organization_registration = OrganizationRegistration.find(params[:id])
  end
end
