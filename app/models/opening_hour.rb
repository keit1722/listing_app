# == Schema Information
#
# Table name: opening_hours
#
#  id         :bigint           not null, primary key
#  day        :integer          not null
#  end_time   :string           not null
#  start_time :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class OpeningHour < ApplicationRecord
  has_many :opening_hour_mappings, dependent: :destroy
  has_many :restaurants,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'Restaurant'
  has_many :activities,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'Activity'
  has_many :hot_springs,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'HotSpring'
  has_many :ski_areas,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'SkiArea'
  has_many :photo_spots,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'PhotoSpot'
  has_many :shops,
           through: :opening_hour_mappings,
           source: :opening_hourable,
           source_type: 'Shop'

  validates :start_time, presence: true
  validates :end_time, presence: true

  enum day: {
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7,
    holiday: 8
  }
end
