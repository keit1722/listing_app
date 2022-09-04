class Organizations::HotSpringsController < Organizations::BaseController
  layout 'mypage_maps'

  def index
    @organization =
      current_user.organizations.find_by!(slug: params[:organization_slug])
    @hot_springs =
      @organization
        .hot_springs
        .page(params[:page])
        .per(20)
        .with_attached_main_image
    render layout: 'mypage'
  end

  def show
    @hot_spring =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hot_springs
        .with_attached_images
        .find_by!(slug: params[:slug])
  end

  def new
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @hot_spring_create_form = HotSpringCreateForm.new(organization)
    @districts = District.all
  end

  def create
    organization =
      current_user.organizations.find_by(slug: params[:organization_slug])
    @hot_spring_create_form =
      HotSpringCreateForm.new(organization, hot_spring_create_params)
    @districts = District.all

    if @hot_spring_create_form.save
      redirect_to organization_hot_springs_path, success: '作成しました'
    else
      flash.now[:error] = '作成できませんでした'
      render :new
    end
  end

  def edit
    @hot_spring =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hot_springs
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hot_spring_update_form = HotSpringUpdateForm.new(@hot_spring)
    @districts = District.all
  end

  def update
    @hot_spring =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hot_springs
        .with_attached_images
        .find_by!(slug: params[:slug])
    @hot_spring_update_form =
      HotSpringUpdateForm.new(@hot_spring, hot_spring_update_params)
    @districts = District.all

    if @hot_spring_update_form.update
      redirect_to organization_hot_spring_path, success: '情報を更新しました'
    else
      flash.now[:error] = '更新できませんでした'
      render :edit
    end
  end

  def destroy
    @hot_spring =
      current_user
        .organizations
        .find_by(slug: params[:organization_slug])
        .hot_springs
        .find_by(slug: params[:slug])

    @hot_spring.destroy!
    redirect_to organization_hot_springs_path, success: '削除しました'
  end

  private

  def hot_spring_create_params
    params
      .require(:hot_spring_create_form)
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
        hot_spring_attributes: [
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

  def hot_spring_update_params
    params
      .require(:hot_spring_update_form)
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
        hot_spring_attributes: [
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
