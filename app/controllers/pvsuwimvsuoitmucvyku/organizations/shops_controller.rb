class Pvsuwimvsuoitmucvyku::Organizations::ShopsController < Pvsuwimvsuoitmucvyku::BaseController
  layout 'mypage_maps'

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @shops =
      @organization.shops.page(params[:page]).per(20).with_attached_main_image
    render layout: 'mypage'
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
    @districts = District.all
    @shop_categories = ShopCategory.all
  end

  def update
    @shop =
      Organization
        .find_by!(slug: params[:organization_slug])
        .shops
        .with_attached_images
        .find_by!(slug: params[:slug])
    @shop_update_form = ShopUpdateForm.new(@shop, shop_params)
    @districts = District.all
    @shop_categories = ShopCategory.all

    if @shop_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_shop_path,
                  success: '情報を更新しました'
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
        reservation_link_attributes: [:link],
        page_show_attributes: %i[reservation_link opening_hours],
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
          :main_image,
          { images: [] },
        ],
      )
  end
end
