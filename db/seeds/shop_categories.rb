puts 'Start inserting seed "shop_categories" ...'

shop_categories = %w[
  お土産
  スポーツショップ
  レンタルショップ
  コンビニ
  スーパー
  薬局
]

shop_categories.each do |shop_category|
  category = ShopCategory.create(name: shop_category)
  puts "\"#{category.name}\" has created!"
end
