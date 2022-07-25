class Admin::Organizations::ShopsController < Admin::BaseController
  layout 'mypage_maps', only: %i[show edit]

  before_action :set_districts, only: %i[edit update]
  before_action :set_shop_categories, only: %i[edit update]

  def index
    @shops =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .page(params[:page])
        .per(20)
        .with_attached_images
  end

  def show
    @shop =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def edit
    @shop =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .with_attached_images
        .find_by!(slug: params[:slug])
    @shop_update_form = ShopUpdateForm.new(@shop)
  end

  def update
    @shop =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .with_attached_images
        .find_by!(slug: params[:slug])
    @shop_update_form = ShopUpdateForm.new(@shop, shop_params)

    if @shop_update_form.update
      redirect_to admin_organization_shop_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def shop_params
    params
      .require(:shop_update_form)
      .permit(
        :district_id,
        opening_hours_attributes: %i[
          start_time_hour
          start_time_minute
          end_time_hour
          end_time_minute
          closed
          day
        ],
        shop_category_ids: [],
        shop_attributes: [
          :name,
          :lat,
          :lng,
          :description,
          :address,
          { images: [] },
        ],
      )
  end

  def set_districts
    @districts = District.all
  end

  def set_shop_categories
    @shop_categories = ShopCategory.all
  end
end
