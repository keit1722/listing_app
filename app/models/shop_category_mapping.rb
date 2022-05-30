# == Schema Information
#
# Table name: shop_category_mappings
#
#  id               :bigint           not null, primary key
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  shop_category_id :bigint
#  shop_id          :bigint
#
# Indexes
#
#  index_shop_category_mappings_on_id_and_category_id  (shop_id,shop_category_id) UNIQUE
#  index_shop_category_mappings_on_shop_category_id    (shop_category_id)
#  index_shop_category_mappings_on_shop_id             (shop_id)
#
# Foreign Keys
#
#  fk_rails_...  (shop_category_id => shop_categories.id)
#  fk_rails_...  (shop_id => shops.id)
#
class ShopCategoryMapping < ApplicationRecord
  validates :shop_id, uniqueness: { scope: :shop_category_id }
end
