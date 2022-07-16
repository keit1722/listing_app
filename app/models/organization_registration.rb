# == Schema Information
#
# Table name: organization_registrations
#
#  id                   :bigint           not null, primary key
#  business_detail      :text             not null
#  organization_address :string           not null
#  organization_name    :string           not null
#  organization_phone   :string           not null
#  token                :string           not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  user_id              :bigint
#
# Indexes
#
#  index_organization_registrations_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class OrganizationRegistration < ApplicationRecord
  belongs_to :user
  has_one :organization_registration_status

  validates :organization_name, length: { maximum: 100 }, presence: true
  validates :organization_address, length: { maximum: 100 }, presence: true
  validates :organization_phone,
            numericality: true,
            length: {
              in: 10..11,
            },
            presence: true
  validates :business_detail, length: { maximum: 10_000 }, presence: true
  validate :used_organization_name

  before_create :create_token

  scope :ordered, -> { order(created_at: :desc) }

  private

  def used_organization_name
    if Organization.exists?(name: organization_name)
      errors.add(
        :organization_name,
        'は既に利用されています。別のものをご入力ください。',
      )
    end
  end

  def create_token
    self.token = SecureRandom.uuid
  end
end
