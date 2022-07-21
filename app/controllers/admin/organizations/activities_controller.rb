class Admin::Organizations::ActivitiesController < ApplicationController
  layout 'mypage_maps', only: %i[show new edit]

  before_action :set_districts, only: %i[new create edit update]

  def index
    @activities =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .page(params[:page])
        .per(20)
        .with_attached_images
    render layout: 'mypage'
  end

  def show
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new; end

  def edit
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form = ActivityUpdateForm.new(@activity)
  end

  def update
    @activity =
      Organization
        .find_by!(slug: params[:organization_slug])
        .activities
        .with_attached_images
        .find_by!(slug: params[:slug])
    @activity_update_form =
      ActivityUpdateForm.new(@activity, activity_update_params)

    if @activity_update_form.update
      redirect_to admin_organization_activity_path,
                  success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def activity_create_params
    params
      .require(:activity_create_form)
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
          :slug,
          :description,
          :address,
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
          { images: [] },
        ],
      )
  end

  def set_districts
    @districts = District.all
  end
end
