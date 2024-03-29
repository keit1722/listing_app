class RestaurantCategoryMapping < ApplicationRecord
  belongs_to :restaurant
  belongs_to :restaurant_category

  validates :restaurant_id, uniqueness: { scope: :restaurant_category_id }
end

# == Schema Information
#
# Table name: restaurant_category_mappings
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  restaurant_category_id :bigint
#  restaurant_id          :bigint
#
# Indexes
#
#  index_restaurant_category_mappings_on_id_and_category_id      (restaurant_id,restaurant_category_id) UNIQUE
#  index_restaurant_category_mappings_on_restaurant_category_id  (restaurant_category_id)
#  index_restaurant_category_mappings_on_restaurant_id           (restaurant_id)
#
