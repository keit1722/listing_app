class Shops::SearchFormsController < ApplicationController
  def search
    @shops =
      SearchWithCategoriesForm
        .new(search_shops_params)
        .search
        .with_attached_main_image
        .includes(:shop_categories, :shop_category_mappings)
        .page(params[:page])
        .per(20)
    @categories = ShopCategory.all
    @shops_count =
      SearchWithCategoriesForm.new(search_shops_params).search.count
    @selected_categories = params[:q][:category_ids]
    @selected_area_groups = params[:q][:area_groups]
    render layout: 'listings_index'
  end

  private

  def search_shops_params
    params
      .fetch(:q, {})
      .permit(:keyword, category_ids: [], area_groups: [])
      .merge(model: 'shop')
  end
end
