class ShopDecorator < ListingsDecorator
  delegate_all

  def arranged_categories
    object.shop_categories.pluck(:name).join(' / ')
  end
end
