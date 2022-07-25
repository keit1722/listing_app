class Admin::Organizations::HotSpringsController < Admin::BaseController
  before_action :set_districts, only: [:edit, :update]

  def index
    @hot_springs =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hot_springs
      .page(params[:page])
      .per(20)
      .with_attached_images
  end

  def show
    @hot_spring =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hot_springs
      .with_attached_images
      .find_by!(slug: params[:slug])
    render layout: 'mypage_maps'
  end

  def edit
    @hot_spring =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hot_springs
      .with_attached_images
      .find_by!(slug: params[:slug])
    @hot_spring_update_form = HotSpringUpdateForm.new(@hot_spring)
    render layout: 'mypage_maps'
  end

  def update
    @hot_spring =
      Organization
      .find_by!(slug: params[:organization_slug])
      .hot_springs
      .with_attached_images
      .find_by!(slug: params[:slug])
    @hot_spring_update_form =
      HotSpringUpdateForm.new(@hot_spring, hot_spring_params)

    if @hot_spring_update_form.update
      redirect_to admin_organization_hot_spring_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def hot_spring_params
    params
      .require(:hot_spring_update_form)
      .permit(
        :district_id,
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        hot_spring_attributes: [
          :name,
          :lat,
          :lng,
          :description,
          :address,
          { images: [] }
        ]
      )
  end

  def set_districts
    @districts = District.all
  end
end
