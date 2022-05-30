# == Schema Information
#
# Table name: districts
#
#  id         :bigint           not null, primary key
#  location   :integer          not null
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_districts_on_name  (name) UNIQUE
#
class District < ApplicationRecord
  has_many :district_mappings, dependent: :destroy
  has_many :restaurants,
           through: :district_mappings,
           source: :districtable,
           source_type: 'Restaurant'
  has_many :hotels,
           through: :district_mappings,
           source: :districtable,
           source_type: 'Hotel'
  has_many :activities,
           through: :district_mappings,
           source: :districtable,
           source_type: 'Activity'
  has_many :hot_springs,
           through: :district_mappings,
           source: :districtable,
           source_type: 'HotSpring'
  has_many :ski_areas,
           through: :district_mappings,
           source: :districtable,
           source_type: 'SkiArea'
  has_many :photo_spots,
           through: :district_mappings,
           source: :districtable,
           source_type: 'PhotoSpot'
  has_many :shops,
           through: :district_mappings,
           source: :districtable,
           source_type: 'Shop'

  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  enum location: { hakuba: 1, otari: 2 }
end
