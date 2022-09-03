class Organizations::PhotoSpotsController < Organizations::BaseController
  layout 'mypage_maps'

  def index
    @organization =
      current_user.organizations.find_by!(slug: params[:organization_slug])
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
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @photo_spot_create_form = PhotoSpotCreateForm.new(organization)
    @districts = District.all
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @photo_spot_create_form =
      PhotoSpotCreateForm.new(organization, photo_spot_create_params)
    @districts = District.all

    if @photo_spot_create_form.save
      redirect_to organization_photo_spots_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @photo_spot =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .with_attached_images
        .find_by!(slug: params[:slug])
    @photo_spot_update_form = PhotoSpotUpdateForm.new(@photo_spot)
    @districts = District.all
  end

  def update
    @photo_spot =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .photo_spots
        .with_attached_images
        .find_by!(slug: params[:slug])
    @photo_spot_update_form =
      PhotoSpotUpdateForm.new(@photo_spot, photo_spot_update_params)
    @districts = District.all

    if @photo_spot_update_form.update
      redirect_to organization_photo_spot_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @photo_spot =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .photo_spots
        .find_by(slug: params[:slug])

    @photo_spot.destroy!
    redirect_to organization_photo_spots_path, success: '削除しました'
  end

  private

  def photo_spot_create_params
    params
      .require(:photo_spot_create_form)
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
        photo_spot_attributes: [
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

  def photo_spot_update_params
    params
      .require(:photo_spot_update_form)
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
        photo_spot_attributes: [
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
