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
         holiday: 8,
       }
end
