class Organizations::SkiAreasController < Organizations::BaseController
  before_action :set_districts, only: %i[new create edit update]

  def index
    @ski_areas =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .page(params[:page])
        .per(20)
        .with_attached_images
  end

  def show
    @ski_area =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @ski_area_create_form = SkiAreaCreateForm.new(organization)
    render layout: 'mypage_maps'
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @ski_area_create_form =
      SkiAreaCreateForm.new(organization, ski_area_create_params)

    if @ski_area_create_form.save
      redirect_to organization_ski_areas_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @ski_area =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    @ski_area_update_form = SkiAreaUpdateForm.new(@ski_area)
    render layout: 'mypage_maps'
  end

  def update
    @ski_area =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    @ski_area_update_form =
      SkiAreaUpdateForm.new(@ski_area, ski_area_update_params)

    if @ski_area_update_form.update
      redirect_to organization_ski_area_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @ski_area =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .ski_areas
        .find_by(slug: params[:slug])

    @ski_area.destroy!
    redirect_to organization_ski_areas_path, success: '削除しました'
  end

  private

  def ski_area_create_params
    params
      .require(:ski_area_create_form)
      .permit(
        :district_id,
        opening_hours_attributes: %i[
          start_time_hour
          start_time_minute
          end_time_hour
          end_time_minute
          closed
          day
        ],
        ski_area_attributes: [
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

  def ski_area_update_params
    params
      .require(:ski_area_update_form)
      .permit(
        :district_id,
        opening_hours_attributes: %i[
          start_time_hour
          start_time_minute
          end_time_hour
          end_time_minute
          closed
          day
        ],
        ski_area_attributes: [
          :name,
          :lat,
          :lng,
          :description,
          :address,
          { images: [] },
        ],
      )
  end
end
