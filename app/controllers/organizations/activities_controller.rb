class Organizations::ActivitiesController < Organizations::BaseController
  layout 'mypage_maps', only: [:show, :new, :edit]

  before_action :set_districts, only: [:new, :create, :edit, :update]

  def index
    @activities =
      current_user
      .organizations
      .find_by!(slug: params[:organization_slug])
      .activities
      .page(params[:page])
      .per(20)
      .with_attached_images
    render layout: 'mypage_maps'
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
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @activity_create_form =
      ActivityCreateForm.new(organization, activity_create_params)

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
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        activity_attributes: [
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

  def activity_update_params
    params
      .require(:activity_update_form)
      .permit(
        :district_id,
        reservation_link_attributes: [:link],
        opening_hours_attributes: [:start_time_hour, :start_time_minute, :end_time_hour, :end_time_minute, :closed, :day],
        activity_attributes: [
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
