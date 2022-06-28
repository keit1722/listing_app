class RestaurantDecorator < ListingsDecorator
  delegate_all

  def arranged_categories
    object.restaurant_categories.pluck(:name).join(' / ')
  end
end
