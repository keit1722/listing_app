class RestaurantDecorator < ListingsDecorator
  delegate_all

  def arranged_categories
    object.restaurant_categories.map(&:name).join(' / ')
  end
end
