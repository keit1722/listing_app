# == Schema Information
#
# Table name: organizations
#
#  id         :bigint           not null, primary key
#  address    :string           not null
#  name       :string           not null
#  phone      :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_organizations_on_name  (name) UNIQUE
#  index_organizations_on_slug  (slug) UNIQUE
#
class Organization < ApplicationRecord
  has_many :organization_users, dependent: :destroy
  has_many :users, through: :organization_users

  validates :name, length: { maximum: 100 }, uniqueness: true, presence: true
  validates :address, length: { maximum: 100 }, presence: true
  validates :phone, numericality: true, length: { in: 10..11 }, presence: true
  validates :slug,
            length: {
              maximum: 30
            },
            uniqueness: true,
            presence: true,
            format: {
              with: /\A[a-z0-9\-]+\z/
            }

  def to_param
    slug
  end
end
