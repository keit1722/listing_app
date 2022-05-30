class OrganizationsController < ApplicationController
  before_action :only_business

  layout 'mypage'

  def index
    @organizations = current_user.organizations
  end

  def show
    @organization = current_user.organizations.find_by!(slug: params[:slug])
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_create_params)
    if @organization.save
      redirect_to organizations_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @organization = current_user.organizations.find_by!(slug: params[:slug])
  end

  def update
    @organization = current_user.organizations.find_by!(slug: params[:slug])
    if @organization.update(organization_update_params)
      redirect_to organization_path, success: '情報を更新しました'
    else
      flash.now[:error] = '情報を更新できませんでした'
      render :edit
    end
  end

  def destroy
    @organization = current_user.organizations.find_by!(slug: params[:slug])
    @organization.destroy!
    redirect_to organizations_path, success: '削除しました'
  end

  private

  def organization_create_params
    params
      .require(:organization)
      .permit(:name, :address, :phone, :slug)
      .merge(user_ids: current_user.id)
  end

  def organization_update_params
    params.require(:organization).permit(:name, :address, :phone)
  end

  def only_business
    redirect_to root_path, error: 'ビジネスユーザー専用の機能です' unless current_user&.business?
  end
end
