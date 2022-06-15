class Organizations::PhotoSpotsController < Organizations::BaseController
  layout :determine_mypage_layout

  before_action :set_districts, only: [:new, :create, :edit, :update]

  def index
    @photo_spots =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .photo_spots
      .page(params[:page])
      .per(20)
      .with_attached_images
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
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @photo_spot_create_form =
      PhotoSpotCreateForm.new(organization, photo_spot_create_params)

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
        photo_spot_attributes: [
          :name,
          :lat,
          :lng,
          :slug,
          :description,
          :address,
          { images: [] }
        ]
      )
  end

  def photo_spot_update_params
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
          { images: [] }
        ]
      )
  end
end
