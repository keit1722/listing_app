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
  validates :link, presence: true
end
