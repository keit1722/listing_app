class Organizations::Hotels::PostsController < Organizations::BaseController
  include OrganizationsPostable

  private

  def set_postable
    @postable =
      current_user
        .organizations
        .find_by!(slug: params[:organization_slug])
        .hotels
        .find_by!(slug: params[:hotel_slug])
  end
end
