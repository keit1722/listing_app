# == Schema Information
#
# Table name: reservation_links
#
#  id         :bigint           not null, primary key
#  link       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ReservationLink < ApplicationRecord
  has_many :reservation_link_mappings, dependent: :destroy
  has_many :restaurants,
           through: :reservation_link_mappings,
           source: :reservation_linkable,
           source_type: 'Restaurant'
  has_many :hotels,
           through: :reservation_link_mappings,
           source: :reservation_linkable,
           source_type: 'Hotel'
  has_many :activities,
           through: :reservation_link_mappings,
           source: :reservation_linkable,
           source_type: 'Activity'

  validates :link, presence: true
end
