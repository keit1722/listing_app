class Announcement < ApplicationRecord
  has_one_attached :image
  has_many :notices, as: :noticeable, dependent: :destroy
  has_many :users, through: :notices

  validates :title, length: { maximum: 100 }, presence: true
  validates :body, length: { maximum: 10_000 }, presence: true
  validates :status, presence: true

  enum status: { published: 1, draft: 2 }

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(count) { ordered.limit(count) }

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

  def create_notices(title)
    notices = User.all.map { |user| Notice.new(user:, noticeable: self) }
    Notice.import notices

    email_receivers = User.select { |user| user.incoming_email.announcement? }
    email_receivers.each do |user|
      NoticeMailer
        .with(user_to: user, announcement: self, title:)
        .announcement
        .deliver_later
    end
  end
end

# == Schema Information
#
# Table name: announcements
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  published_before :boolean          default(FALSE), not null
#  status           :integer          default("published"), not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  poster_id        :integer          not null
#
