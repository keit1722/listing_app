class Admin::Organizations::PhotoSpotsController < Admin::BaseController
  before_action :set_districts, only: %i[edit update]

  def index
    @photo_spots =
      Organization
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .page(params[:page])
        .per(20)
        .with_attached_images
  end

  def show
    @photo_spot =
      Organization
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def edit
    @photo_spot =
      Organization
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .with_attached_images
        .find_by!(slug: params[:slug])
    @photo_spot_update_form = PhotoSpotUpdateForm.new(@photo_spot)
    render layout: 'mypage_maps'
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

    if @photo_spot_update_form.update
      redirect_to admin_organization_photo_spot_path,
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
        photo_spot_attributes: [
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
