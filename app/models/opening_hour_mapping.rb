# == Schema Information
#
# Table name: opening_hour_mappings
#
#  id                    :bigint           not null, primary key
#  opening_hourable_type :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  opening_hour_id       :bigint
#  opening_hourable_id   :bigint
#
# Indexes
#
#  index_opening_hour_mappings_on_opening_hour_id          (opening_hour_id)
#  index_polymorphic_opening_hour_mappings_on_id_and_type  (opening_hourable_type,opening_hourable_id)
#
# Foreign Keys
#
#  fk_rails_...  (opening_hour_id => opening_hours.id)
#
class OpeningHourMapping < ApplicationRecord
end
