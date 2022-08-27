class Organizations::HotelsController < Organizations::BaseController
  before_action :set_districts, only: %i[new create edit update]

  def index
    @organization =
      current_user.organizations.find_by!(slug: params[:organization_slug])
    @hotels =
      @organization.hotels.page(params[:page]).per(20).with_attached_main_image
  end

  def show
    @hotel =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @hotel_create_form = HotelCreateForm.new(organization)
    render layout: 'mypage_maps'
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @hotel_create_form = HotelCreateForm.new(organization, hotel_create_params)

    if @hotel_create_form.save
      redirect_to organization_hotels_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @hotel =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel)
    render layout: 'mypage_maps'
  end

  def update
    @hotel =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel, hotel_update_params)

    if @hotel_update_form.update
      redirect_to organization_hotel_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @hotel =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .hotels
        .find_by(slug: params[:slug])

    @hotel.destroy!
    redirect_to organization_hotels_path, success: '削除しました'
  end

  private

  def hotel_create_params
    params
      .require(:hotel_create_form)
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
        hotel_attributes: [
          :name,
          :lat,
          :lng,
          :slug,
          :description,
          :address,
          :main_image,
          { images: [] },
        ],
      )
  end

  def hotel_update_params
    params
      .require(:hotel_update_form)
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
        hotel_attributes: [
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
