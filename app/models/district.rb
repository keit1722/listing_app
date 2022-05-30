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
  validates :name, presence: true, uniqueness: true
  validates :location, presence: true

  enum location: { hakuba: 1, otari: 2 }
end
