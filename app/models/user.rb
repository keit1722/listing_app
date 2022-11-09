class User < ApplicationRecord
  authenticates_with_sorcery!

  generate_public_uid generator:
                        PublicUid::Generators::HexStringSecureRandom.new(20)

  before_save { self.email = email.downcase }

  has_many :organization_users, dependent: :destroy
  has_many :organizations, through: :organization_users
  has_many :bookmarks, dependent: :destroy
  has_many :organization_registrations, dependent: :destroy
  has_many :restaurant_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'Restaurant'
  has_many :hotel_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'Hotel'
  has_many :activity_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'Activity'
  has_many :hot_spring_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'HotSpring'
  has_many :ski_area_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'SkiArea'
  has_many :photo_spot_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'PhotoSpot'
  has_many :shop_bookmarks,
           through: :bookmarks,
           source: :bookmarkable,
           source_type: 'Shop'
  has_many :notices, dependent: :destroy
  has_many :post_notices,
           through: :notices,
           source: :noticeable,
           source_type: 'Post'

  has_many :authentications, dependent: :destroy
  accepts_nested_attributes_for :authentications

  has_one :incoming_email, dependent: :destroy

  has_one_attached :avatar

  validates :password,
            presence: true,
            length: {
              minimum: 6
            },
            if: -> { new_record? || changes[:crypted_password] }
  validates :password,
            confirmation: true,
            if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation,
            presence: true,
            if: -> { new_record? || changes[:crypted_password] }

  validates :email,
            uniqueness: true,
            presence: true,
            length: {
              maximum: 100
            },
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
            }
  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :username, length: { maximum: 100 }, on: :create
  validates :username, presence: true, length: { maximum: 100 }, on: :update

  validates :reset_password_token, uniqueness: true, allow_nil: true
  validates :avatar, content_type: [:png, :jpg, :jpeg]

  enum role: { general: 1, business: 2, admin: 9 }

  after_create { create_incoming_email }
  before_create { self.username = '名無しユーザー' if username.blank? }

  def to_param
    public_uid
  end

  def bookmark(bookmarkable)
    Bookmark.create(bookmarkable:, user_id: id)
  end

  def unbookmark(bookmarkable)
    Bookmark.find_by(bookmarkable:, user_id: id).destroy
  end

  def bookmark?(bookmarkable)
    bookmarks.find_by(bookmarkable:)
  end

  def resign(organization)
    organizations.destroy(organization)
  end
end

# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  activation_state                    :string
#  activation_token                    :string
#  activation_token_expires_at         :datetime
#  crypted_password                    :string
#  email                               :string           not null
#  first_name                          :string           not null
#  last_name                           :string           not null
#  public_uid                          :string
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string
#  reset_password_token_expires_at     :datetime
#  role                                :integer          default("general"), not null
#  salt                                :string
#  username                            :string           not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
# Indexes
#
#  index_users_on_activation_token      (activation_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_public_uid            (public_uid) UNIQUE
#  index_users_on_reset_password_token  (reset_password_token)
#
