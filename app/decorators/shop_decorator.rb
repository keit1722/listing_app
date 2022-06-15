class ShopDecorator < ApplicationDecorator
  delegate_all

  def arranged_categories
    object.shop_categories.map(&:name).join(' / ')
  end
end
