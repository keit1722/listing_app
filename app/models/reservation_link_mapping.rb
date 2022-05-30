# == Schema Information
#
# Table name: reservation_link_mappings
#
#  id                        :bigint           not null, primary key
#  reservation_linkable_type :string
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  reservation_link_id       :bigint
#  reservation_linkable_id   :bigint
#
# Indexes
#
#  index_polymorphic_reservation_link_mappings_on_id_and_type  (reservation_linkable_type,reservation_linkable_id)
#  index_reservation_link_mappings_on_reservation_link_id      (reservation_link_id)
#
# Foreign Keys
#
#  fk_rails_...  (reservation_link_id => reservation_links.id)
#
class ReservationLinkMapping < ApplicationRecord
  belongs_to :reservation_link
  belongs_to :reservation_linkable, polymorphic: true
end
