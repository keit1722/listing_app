class Pvsuwimvsuoitmucvyku::Organizations::HotelsController < Pvsuwimvsuoitmucvyku::BaseController
  layout 'mypage_maps'

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @hotels =
      @organization.hotels.page(params[:page]).per(20).with_attached_main_image
    render layout: 'mypage'
  end

  def show
    @hotel =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hotels
      .with_attached_images
      .find_by!(slug: params[:slug])
  end

  def edit
    @hotel =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hotels
      .with_attached_images
      .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel)
    @districts = District.all
  end

  def update
    @hotel =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hotels
      .with_attached_images
      .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel, hotel_params)
    @districts = District.all

    if @hotel_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_hotel_path,
                  success: '情報を更新しました'
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
        page_show_attributes: [:reservation_link, :opening_hours],
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        hotel_attributes: [
          :name,
          :lat,
          :lng,
          :description,
          :address,
          :main_image,
          { images: [] }
        ]
      )
  end
end
