# == Schema Information
#
# Table name: posts
#
#  id            :bigint           not null, primary key
#  body          :text             not null
#  postable_type :string
#  status        :integer          default(1), not null
#  title         :string           not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  postable_id   :bigint
#
# Indexes
#
#  index_posts_on_postable_type_and_postable_id  (postable_type,postable_id)
#
class Post < ApplicationRecord
  belongs_to :postable, polymorphic: true

  has_one_attached :image

  validates :title, length: { maximum: 100 }, presence: true
  validates :body, length: { maximum: 10_000 }, presence: true
  validates :status, presence: true

  enum status: { published: 1, draft: 2 }

  scope :recent, -> { order(created_at: :desc) }

  def previous
    postable
      .posts
      .published
      .where('created_at < ?', self.created_at)
      .order('created_at DESC')
      .first
  end

  def next
    postable
      .posts
      .published
      .where('created_at > ?', self.created_at)
      .order('created_at ASC')
      .first
  end
end
