class OrganizationUsersController < ApplicationController
  before_action :require_login, only: [:destroy]

  def destroy
    @organization = Organization.find_by(slug: params[:slug])
    current_user.resign(@organization)
    redirect_to organizations_path,
                success: "#{@organization.name}から退会しました"
  end
end
