# == Schema Information
#
# Table name: opening_hours
#
#  id                    :bigint           not null, primary key
#  closed                :boolean          default(FALSE), not null
#  day                   :integer          not null
#  end_time_hour         :string           not null
#  end_time_minute       :string           not null
#  opening_hourable_type :string
#  start_time_hour       :string           not null
#  start_time_minute     :string           not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opening_hourable_id   :bigint
#
# Indexes
#
#  index_polymorphic_opening_hour_mappings_on_id_and_type  (opening_hourable_type,opening_hourable_id)
#
class OpeningHour < ApplicationRecord
  belongs_to :opening_hourable, polymorphic: true

  validates :start_time_hour, presence: true
  validates :start_time_minute, presence: true
  validates :end_time_hour, presence: true
  validates :end_time_minute, presence: true
  validates :day, presence: true

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

  scope :early, -> { order(created_at: :asc) }
end
