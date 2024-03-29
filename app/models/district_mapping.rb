class DistrictMapping < ApplicationRecord
  belongs_to :district
  belongs_to :districtable, polymorphic: true

  validates :districtable_id, uniqueness: { scope: :districtable_type }
end

# == Schema Information
#
# Table name: district_mappings
#
#  id                :bigint           not null, primary key
#  districtable_type :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  district_id       :bigint
#  districtable_id   :bigint
#
# Indexes
#
#  index_district_mappings_on_district_id                           (district_id)
#  index_district_mappings_on_districtable_id_and_type              (districtable_id,districtable_type) UNIQUE
#  index_polymorphic_district_mappings_on_districtable_id_and_type  (districtable_type,districtable_id)
#
