# == Schema Information
#
# Table name: reservation_links
#
#  id                        :bigint           not null, primary key
#  link                      :string           not null
#  reservation_linkable_type :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  reservation_linkable_id   :bigint
#
# Indexes
#
#  index_polymorphic_reservation_link_mappings_on_id_and_type  (reservation_linkable_type,reservation_linkable_id)
#
class ReservationLink < ApplicationRecord
  belongs_to :reservation_linkable, polymorphic: true

  validates :link, length: { maximum: 100 }, presence: true
end