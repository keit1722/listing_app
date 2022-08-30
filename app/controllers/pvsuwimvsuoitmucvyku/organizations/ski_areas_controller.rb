class Pvsuwimvsuoitmucvyku::Organizations::SkiAreasController < Pvsuwimvsuoitmucvyku::BaseController
  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @ski_areas =
      @organization
        .ski_areas
        .page(params[:page])
        .per(20)
        .with_attached_main_image
  end

  def show
    @ski_area =
      Organization
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def edit
    @ski_area =
      Organization
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    @ski_area_update_form = SkiAreaUpdateForm.new(@ski_area)
    @districts = District.all
    render layout: 'mypage_maps'
  end

  def update
    @ski_area =
      Organization
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .with_attached_images
        .find_by!(slug: params[:slug])
    @ski_area_update_form = SkiAreaUpdateForm.new(@ski_area, ski_area_params)
    @districts = District.all

    if @ski_area_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_ski_area_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def ski_area_params
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
          :main_image,
          { images: [] },
        ],
      )
  end
end
