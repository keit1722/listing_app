class Organizations::SkiAreas::PostsController < Organizations::BaseController
  include OrganizationsPostable

  private

  def set_postable
    @postable =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .ski_areas
        .find_by!(slug: params[:ski_area_slug])
  end
end
