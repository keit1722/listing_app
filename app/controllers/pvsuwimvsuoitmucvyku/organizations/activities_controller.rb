class Pvsuwimvsuoitmucvyku::Organizations::ActivitiesController < Pvsuwimvsuoitmucvyku::BaseController
  before_action :set_districts, only: %i[edit update]

  def index
    @organization = Organization.find_by!(slug: params[:organization_slug])
    @activities =
      @organization
        .activities
        .page(params[:page])
        .per(20)
        .with_attached_main_image
  end

  def show
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def edit
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form = ActivityUpdateForm.new(@activity)
    render layout: 'mypage_maps'
  end

  def update
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form = ActivityUpdateForm.new(@activity, activity_params)

    if @activity_update_form.update
      redirect_to pvsuwimvsuoitmucvyku_organization_activity_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def activity_params
    params
      .require(:activity_update_form)
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
        activity_attributes: [
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

  def set_districts
    @districts = District.all
  end
end
