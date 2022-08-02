class Admin::Organizations::HotelsController < Admin::BaseController
  before_action :set_districts, only: %i[edit update]

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @hotels =
      @organization.hotels.page(params[:page]).per(20).with_attached_images
  end

  def show
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def edit
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel)
    render layout: 'mypage_maps'
  end

  def update
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel, hotel_params)

    if @hotel_update_form.update
      redirect_to admin_organization_hotel_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def hotel_params
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
          { images: [] },
        ],
      )
  end

  def set_districts
    @districts = District.all
  end
end
