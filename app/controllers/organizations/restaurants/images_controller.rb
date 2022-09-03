class Organizations::Restaurants::ImagesController < ApplicationController
  def destroy
    @image = ActiveStorage::Attachment.find(params[:id])
    @image.purge

    render 'shared/organizations/listings/images/destroy'
  end
end
