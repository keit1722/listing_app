class Admin::OrganizationsController < Admin::BaseController
  layout 'mypage'

  def index
    @organizations = Organization.page(params[:page]).per(20)
  end

  def show
    @organization = Organization.find_by!(slug: params[:slug])
  end

  def edit
    @organization = Organization.find_by!(slug: params[:slug])
  end

  def update
    @organization = Organization.find_by!(slug: params[:slug])
    if @organization.update(organization_params)
      redirect_to admin_organization_path, success: '情報を更新しました'
    else
      flash.now[:error] = '情報を更新できませんでした'
      render :edit
    end
  end

  def destroy
    @organization = Organization.find_by!(slug: params[:slug])
    @organization.destroy!
    redirect_to admin_organizations_path, success: '削除しました'
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :address, :phone, :slug)
  end
end
