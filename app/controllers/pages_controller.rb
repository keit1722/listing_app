class PagesController < ApplicationController
  layout 'home'

  def home; end

  def search
    category = params[:q][:category]
    listings = SearchHomeForm.new(search_params).search

    instance_variable_set(
      "@#{category}",
      resolve_n1(category, listings)
        .with_attached_main_image
        .page(params[:page])
        .per(20),
    )
    instance_variable_set("@#{category}_count", listings.count)

    @selected_categories = 'all'
    @selected_area_groups = params[:q][:area].presence || 'all'
    @keyword = params[:q][:keyword]

    render template: "#{category}/search", layout: 'listings_index'
  end

  def term; end

  def privacy; end

  def cookie; end

  private

  def resolve_n1(category, listings)
    case category
    when 'restaurants'
      listings.includes(:restaurant_categories, :restaurant_category_mappings)
    when 'shops'
      listings.includes(:shop_categories, :shop_category_mappings)
    else
      listings
    end
  end

  def search_params
    params.fetch(:q, {}).permit(:keyword, :category, :area)
  end
end
