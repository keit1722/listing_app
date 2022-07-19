# == Schema Information
#
# Table name: organization_invitations
#
#  id              :bigint           not null, primary key
#  email           :string           not null
#  expires_at      :datetime         not null
#  status          :integer          default("untouched"), not null
#  token           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  inviter_id      :integer          not null
#  organization_id :bigint
#
# Indexes
#
#  index_organization_invitations_on_organization_id  (organization_id)
#  index_organization_invitations_on_token            (token) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class OrganizationInvitation < ApplicationRecord
  belongs_to :organization

  has_many :notices, as: :noticeable, dependent: :destroy
  has_many :users, through: :notices

  validates :email,
            presence: true,
            format: {
              with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
            }
  validates :inviter_id, presence: true
  validates :expires_at, presence: true
  validate :belonged_user

  enum status: { untouched: 1, accepted: 2, rejected: 3 }

  before_create :create_token
  before_save { self.email = email.downcase }

  scope :ordered, -> { order(created_at: :desc) }

  def create_notice
    user = User.find_by(email: email)
    return if user.nil?

    Notice.create(user: user, noticeable: self)
    NoticeMailer
      .with(user_to: user, organization_invitation: self)
      .organization_invitation
      .deliver_later
  end

  def to_param
    token
  end

  private

  def belonged_user
    errors.add(:email, 'を利用しているユーザーは既にメンバーです。') if organization.users.exists?(email: email)
  end

  def create_token
    self.token = SecureRandom.uuid
  end
end
