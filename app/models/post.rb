class Post < ApplicationRecord
  belongs_to :postable, polymorphic: true
  has_many :users, through: :notices
  has_one_attached :image

  include NoticeableAssociation
  include Rails.application.routes.url_helpers

  validates :title, length: { maximum: 100 }, presence: true
  validates :body, length: { maximum: 10_000 }, presence: true
  validates :status, presence: true

  enum status: { published: 1, draft: 2 }

  scope :ordered, -> { order(created_at: :desc) }
  scope :recent, ->(count) { ordered.limit(count) }

  def previous
    postable
      .posts
      .published
      .where('created_at < ?', created_at)
      .order('created_at DESC')
      .first
  end

  def next
    postable
      .posts
      .published
      .where('created_at > ?', created_at)
      .order('created_at ASC')
      .first
  end

  def create_notices(title)
    notices =
      postable.users.map { |user| Notice.new(user:, noticeable: self) }
    Notice.import notices

    email_receivers = postable.users.select { |user| user.incoming_email.post? }
    email_receivers.each do |user|
      NoticeMailer
        .with(user_to: user, post: self, title:)
        .post
        .deliver_later
    end
  end

  def path_for_notice
    [postable, self]
  end
end

# == Schema Information
#
# Table name: posts
#
#  id               :bigint           not null, primary key
#  body             :text             not null
#  postable_type    :string
#  published_before :boolean          default(FALSE), not null
#  status           :integer          not null
#  title            :string           not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  postable_id      :bigint
#
# Indexes
#
#  index_posts_on_postable_type_and_postable_id  (postable_type,postable_id)
#
