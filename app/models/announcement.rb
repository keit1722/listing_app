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

  has_many :notices, as: :noticeable, dependent: :destroy
  has_many :users, through: :notices

  has_one_attached :image

  enum status: { published: 1, draft: 2 }

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(count) { ordered.limit(count) }

  after_create_commit :create_notices

  def previous
    Announcement
      .published
      .where('created_at < ?', created_at)
      .order('created_at DESC')
      .first
  end

  def next
    Announcement
      .published
      .where('created_at > ?', created_at)
      .order('created_at ASC')
      .first
  end

  private

  def create_notices
    return if draft?

    notices =
      User.not_admin.map { |user| Notice.new(user: user, noticeable: self) }
    Notice.import notices

    User.not_admin.each do |user|
      NoticeMailer
        .with(user_to: user, announcement: self)
        .announcement
        .deliver_later
    end
  end
end
