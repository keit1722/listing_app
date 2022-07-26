# == Schema Information
#
# Table name: announcements
#
#  id         :bigint           not null, primary key
#  body       :text             not null
#  status     :integer          default("published"), not null
#  title      :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  poster_id  :integer          not null
#
class Announcement < ApplicationRecord
  validates :title, length: { maximum: 100 }, presence: true
  validates :body, length: { maximum: 10_000 }, presence: true
  validates :status, presence: true

  enum status: { published: 1, draft: 2 }

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(count) { ordered.limit(count) }
end
