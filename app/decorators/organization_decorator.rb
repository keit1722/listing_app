class OrganizationDecorator < ApplicationDecorator
  delegate_all

  def arranged_users
    object.users.map { |user| user.decorate.full_name }.join(' / ')
  end

  def arranged_restaurants
    object.restaurants.pluck(:name).join(' / ')
  end

  def arranged_hotels
    object.hotels.pluck(:name).join(' / ')
  end

  def arranged_activities
    object.activities.pluck(:name).join(' / ')
  end

  def arranged_hot_springs
    object.hot_springs.pluck(:name).join(' / ')
  end

  def arranged_ski_areas
    object.ski_areas.pluck(:name).join(' / ')
  end

  def arranged_photo_spots
    object.photo_spots.pluck(:name).join(' / ')
  end

  def arranged_shops
    object.shops.pluck(:name).join(' / ')
  end
end
