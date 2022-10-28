puts 'Start inserting seed "restaurant_categories" ...'

restaurant_categories = %w[
  和食
  洋食
  中華
  そば
  寿司
  焼き肉
  ラーメン
  カフェ
  居酒屋
  バー
  スイーツ
]

restaurant_categories.each do |restaurant_category|
  category = RestaurantCategory.create(name: restaurant_category)
  puts "\"#{category.name}\" has created!"
end
