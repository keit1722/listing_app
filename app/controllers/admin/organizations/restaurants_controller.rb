class Admin::Organizations::RestaurantsController < ApplicationController
  layout 'mypage_maps', only: %i[show new edit]

  before_action :set_districts, only: %i[new create edit update]
  before_action :set_restaurant_categories, only: %i[new create edit update]

  def index
    @restaurants =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .page(params[:page])
        .per(20)
        .with_attached_images
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

  def new; end

  def edit
    @restaurant =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form = RestaurantUpdateForm.new(@restaurant)
  end

  def update
    @restaurant =
      Organization
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form =
      RestaurantUpdateForm.new(@restaurant, restaurant_update_params)

    if @restaurant_update_form.update
      redirect_to admin_organization_restaurant_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def restaurant_create_params
    params
      .require(:restaurant_create_form)
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
          :slug,
          :description,
          :address,
          { images: [] },
        ],
      )
  end

  def restaurant_update_params
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
          { images: [] },
        ],
      )
  end

  def set_districts
    @districts = District.all
  end

  def set_restaurant_categories
    @restaurant_categories = RestaurantCategory.all
  end
end
