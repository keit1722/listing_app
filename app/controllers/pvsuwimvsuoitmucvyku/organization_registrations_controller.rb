class Pvsuwimvsuoitmucvyku::OrganizationRegistrationsController < Pvsuwimvsuoitmucvyku::BaseController
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
