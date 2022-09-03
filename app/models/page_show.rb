class PageShow < ApplicationRecord
end

# == Schema Information
#
# Table name: page_shows
#
#  id                 :bigint           not null, primary key
#  opening_hours      :boolean          default(TRUE), not null
#  page_showable_type :string
#  reservation_link   :boolean          default(TRUE), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  page_showable_id   :bigint
#
# Indexes
#
#  index_page_shows_on_page_showable_type_and_page_showable_id  (page_showable_type,page_showable_id)
#
