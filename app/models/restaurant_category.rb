# == Schema Information
#
# Table name: restaurant_categories
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_restaurant_categories_on_name  (name) UNIQUE
#
class RestaurantCategory < ApplicationRecord
  validates :name, presence: true
end
