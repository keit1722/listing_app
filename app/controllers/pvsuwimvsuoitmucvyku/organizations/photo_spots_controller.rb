class Pvsuwimvsuoitmucvyku::Organizations::PhotoSpotsController < Pvsuwimvsuoitmucvyku::BaseController
  layout 'mypage_maps'

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @photo_spots =
      @organization
      .photo_spots
      .page(params[:page])
      .per(20)
      .with_attached_main_image
    render layout: 'mypage'
  end

  def show
    @photo_spot =
      Organization
      .find_by!(slug: params[:organization_slug])
      .photo_spots
      .with_attached_images
      .find_by!(slug: params[:slug])
  end

  def edit
    @photo_spot =
      Organization
      .find_by!(slug: params[:organization_slug])
      .photo_spots
      .with_attached_images
      .find_by!(slug: params[:slug])
    @photo_spot_update_form = PhotoSpotUpdateForm.new(@photo_spot)
    @districts = District.all
  end

  def update
    @photo_spot =
      Organization
      .find_by!(slug: params[:organization_slug])
      .photo_spots
      .with_attached_images
      .find_by!(slug: params[:slug])
    @photo_spot_update_form =
      PhotoSpotUpdateForm.new(@photo_spot, photo_spot_params)
    @districts = District.all

    if @photo_spot_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_photo_spot_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def photo_spot_params
    params
      .require(:photo_spot_update_form)
      .permit(
        :district_id,
        reservation_link_attributes: [:link],
        page_show_attributes: [:reservation_link, :opening_hours],
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        photo_spot_attributes: [
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
