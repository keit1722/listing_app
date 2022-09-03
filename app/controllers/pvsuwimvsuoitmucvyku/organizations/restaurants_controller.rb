class Pvsuwimvsuoitmucvyku::Organizations::RestaurantsController < Pvsuwimvsuoitmucvyku::BaseController
  layout 'mypage_maps'

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @restaurants =
      @organization
        .restaurants
        .page(params[:page])
        .per(20)
        .with_attached_main_image
    render layout: 'mypage'
  end

  def show
    @restaurant =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def edit
    @restaurant =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form = RestaurantUpdateForm.new(@restaurant)
    @districts = District.all
    @restaurant_categories = RestaurantCategory.all
  end

  def update
    @restaurant =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form =
      RestaurantUpdateForm.new(@restaurant, restaurant_params)
    @districts = District.all
    @restaurant_categories = RestaurantCategory.all

    if @restaurant_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_restaurant_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def restaurant_params
    params
      .require(:restaurant_update_form)
      .permit(
        :district_id,
        reservation_link_attributes: [:link],
        opening_hours_attributes: %i[
          start_time_hour
          start_time_minute
          end_time_hour
          end_time_minute
          closed
          day
        ],
        restaurant_category_ids: [],
        restaurant_attributes: [
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
