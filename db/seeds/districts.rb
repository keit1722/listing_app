puts 'Start inserting seed "districs" ...'

hakuba_districts = %w[
  内山
  佐野
  沢渡
  三日市場
  堀之内
  飯田
  飯森
  深空
  八方口
  瑞穂
  八方
  落倉
  切久保
  新田
  森上
  塩島
  通
  立の間
  青鬼
  野平
  大出
  白馬町
  蕨平
  嶺方
  エコーランド
  どんぐり
  みそら野
  和田野
  山麓
  めいてつ
]

otari_districts = %w[北小谷 千国 中土]

hakuba_districts.each do |hakuba_district|
  district = District.create(name: hakuba_district, location: 'hakuba')
  puts "\"#{district.name}\" has created!"
end

otari_districts.each do |otari_district|
  district = District.create(name: otari_district, location: 'otari')
  puts "\"#{district.name}\" has created!"
end
