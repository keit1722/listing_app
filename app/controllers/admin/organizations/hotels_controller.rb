class Admin::Organizations::HotelsController < ApplicationController
  layout 'mypage_maps', only: %i[show new edit]

  before_action :set_districts, only: %i[new create edit update]

  def index
    @hotels =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .page(params[:page])
        .per(20)
        .with_attached_images
    render layout: 'mypage'
  end

  def show
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new; end

  def edit
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel)
  end

  def update
    @hotel =
      Organization
        .find_by!(slug: params[:organization_slug])
        .hotels
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hotel_update_form = HotelUpdateForm.new(@hotel, hotel_update_params)

    if @hotel_update_form.update
      redirect_to admin_organization_hotel_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  private

  def hotel_create_params
    params
      .require(:hotel_create_form)
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
        hotel_attributes: [
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

  def hotel_update_params
    params
      .require(:hotel_update_form)
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
        hotel_attributes: [
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
