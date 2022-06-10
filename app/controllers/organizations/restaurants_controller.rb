class Organizations::RestaurantsController < Organizations::BaseController
  layout :determine_mypage_layout

  before_action :set_districts_restaurant_categories,
                only: %i[new create edit update]

  def index
    @restaurants =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .page(params[:page])
        .per(20)
        .with_attached_images
  end

  def show
    @restaurant =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @restaurant_create_form = RestaurantCreateForm.new(organization)
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @restaurant_create_form =
      RestaurantCreateForm.new(organization, restaurant_create_params)

    if @restaurant_create_form.save
      redirect_to organization_restaurants_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @restaurant =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form = RestaurantUpdateForm.new(@restaurant)
  end

  def update
    @restaurant =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .restaurants
        .with_attached_images
        .find_by!(slug: params[:slug])
    @restaurant_update_form =
      RestaurantUpdateForm.new(@restaurant, restaurant_update_params)

    if @restaurant_update_form.update
      redirect_to organization_restaurant_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @restaurant =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .restaurants
        .find_by(slug: params[:slug])

    @restaurant.destroy!
    redirect_to organization_restaurants_path, success: '削除しました'
  end

  private

  def restaurant_create_params
    params
      .require(:restaurant_create_form)
      .permit(
        :district_id,
        reservation_link_attributes: %i[link],
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
          images: [],
        ],
      )
  end

  def restaurant_update_params
    params
      .require(:restaurant_update_form)
      .permit(
        :district_id,
        reservation_link_attributes: %i[link],
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
          images: [],
        ],
      )
  end

  def set_districts_restaurant_categories
    @districts = District.all
    @restaurant_categories = RestaurantCategory.all
  end
end
