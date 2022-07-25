class Organizations::ShopsController < Organizations::BaseController
  before_action :set_districts, only: [:new, :create, :edit, :update]
  before_action :set_shop_categories, only: [:new, :create, :edit, :update]

  def index
    @shops =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .shops
      .page(params[:page])
      .per(20)
      .with_attached_images
  end

  def show
    @shop =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .shops
      .with_attached_images
      .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @shop_create_form = ShopCreateForm.new(organization)
    render layout: 'mypage_maps'
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @shop_create_form = ShopCreateForm.new(organization, shop_create_params)

    if @shop_create_form.save
      redirect_to organization_shops_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @shop =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .shops
      .with_attached_images
      .find_by!(slug: params[:slug])
    @shop_update_form = ShopUpdateForm.new(@shop)
    render layout: 'mypage_maps'
  end

  def update
    @shop =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .shops
      .with_attached_images
      .find_by!(slug: params[:slug])
    @shop_update_form = ShopUpdateForm.new(@shop, shop_update_params)

    if @shop_update_form.update
      redirect_to organization_shop_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @shop =
      current_user
      .organizations
      .find_by(slug: params[:organization_slug])
      .shops
      .find_by(slug: params[:slug])

    @shop.destroy!
    redirect_to organization_shops_path, success: '削除しました'
  end

  private

  def shop_create_params
    params
      .require(:shop_create_form)
      .permit(
        :district_id,
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        shop_category_ids: [],
        shop_attributes: [
          :name,
          :lat,
          :lng,
          :slug,
          :description,
          :address,
          { images: [] }
        ]
      )
  end

  def shop_update_params
    params
      .require(:shop_update_form)
      .permit(
        :district_id,
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        shop_category_ids: [],
        shop_attributes: [
          :name,
          :lat,
          :lng,
          :description,
          :address,
          { images: [] }
        ]
      )
  end

  def set_shop_categories
    @shop_categories = ShopCategory.all
  end
end
