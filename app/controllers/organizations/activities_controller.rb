class Organizations::ActivitiesController < Organizations::BaseController
  layout 'mypage_maps'

  def index
    @organization =
      current_user.organizations.find_by!(slug: params[:organization_slug])
    @activities =
      @organization
        .activities
        .page(params[:page])
        .per(20)
        .with_attached_main_image
    render layout: 'mypage'
  end

  def show
    @activity =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @activity_create_form = ActivityCreateForm.new(organization)
    @districts = District.all
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @activity_create_form =
      ActivityCreateForm.new(organization, activity_create_params)
    @districts = District.all

    if @activity_create_form.save
      redirect_to organization_activities_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @activity =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form = ActivityUpdateForm.new(@activity)
    @districts = District.all
  end

  def update
    @activity =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form =
      ActivityUpdateForm.new(@activity, activity_update_params)
    @districts = District.all

    if @activity_update_form.update
      redirect_to organization_activity_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @activity =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .activities
        .find_by(slug: params[:slug])

    @activity.destroy!
    redirect_to organization_activities_path, success: '削除しました'
  end

  private

  def activity_create_params
    params
      .require(:activity_create_form)
      .permit(
        :district_id,
        reservation_link_attributes: [:link],
        page_show_attributes: %i[reservation_link opening_hours],
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
          :slug,
          :description,
          :address,
          :main_image,
          { images: [] },
        ],
      )
  end

  def activity_update_params
    params
      .require(:activity_update_form)
      .permit(
        :district_id,
        reservation_link_attributes: [:link],
        page_show_attributes: %i[reservation_link opening_hours],
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
end
