class Admin::Organizations::SkiAreas::PostsController < Admin::Organizations::PostsController
  before_action :set_postable

  private

  def set_postable
    @postable =
      Organization
      .find_by!(slug: params[:organization_slug])
      .ski_areas
      .find_by!(slug: params[:ski_area_slug])
  end
end
