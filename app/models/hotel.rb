# == Schema Information
#
# Table name: hotels
#
#  id              :bigint           not null, primary key
#  address         :string           not null
#  description     :text             not null
#  lat             :float            not null
#  lng             :float            not null
#  name            :string           not null
#  slug            :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  organization_id :bigint
#
# Indexes
#
#  index_hotels_on_name             (name) UNIQUE
#  index_hotels_on_organization_id  (organization_id)
#  index_hotels_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class Hotel < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :organization

  has_many :district_mappings, as: :districtable, dependent: :destroy
  has_many :districts, through: :district_mappings
  has_one :reservation_link, as: :reservation_linkable, dependent: :destroy

  has_many_attached :images

  validates :name, length: { maximum: 100 }, uniqueness: true, presence: true
  validates :address, length: { maximum: 100 }, presence: true
  validates_with CoordinateValidator
  validates :slug,
            length: {
              maximum: 100,
            },
            uniqueness: true,
            presence: true,
            format: {
              with: /\A[a-z0-9\-]+\z/,
            }
  validates :description, length: { maximum: 10_000 }, presence: true
  validates :images,
            attached: true,
            limit: {
              max: 5,
            },
            content_type: %i[png jpg jpeg]

  def to_param
    slug
  end
end
