class Shops::PostsController < ApplicationController
  include Postable

  private

  def set_postable
    @postable = Shop.find_by(slug: params[:shop_slug])
  end
end
