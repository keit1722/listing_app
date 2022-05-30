puts 'Start inserting seed "shop_categories" ...'

shop_categories = %w[お土産 スポーツショップ コンビニ スーパー]

shop_categories.each do |shop_category|
  ShopCategory.create(name: shop_category)
  puts "\"#{shop_category}\" has created!"
end
