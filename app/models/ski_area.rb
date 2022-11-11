class SkiArea < ApplicationRecord
  belongs_to :organization
  has_many_attached :images
  has_one_attached :main_image

  validates :name, length: { maximum: 100 }, uniqueness: true, presence: true
  validates :address, length: { maximum: 100 }, presence: true
  validates_with CoordinateValidator
  validates :slug,
            length: {
              maximum: 100
            },
            uniqueness: true,
            presence: true,
            format: {
              with: /\A[a-z0-9\-]+\z/
            }
  validates :description, length: { maximum: 10_000 }, presence: true
  validates :main_image, attached: true, content_type: [:png, :jpg, :jpeg]
  validates :images, limit: { max: 4 }, content_type: [:png, :jpg, :jpeg]

  include ActiveModel::Validations
  include DistrictableAssociation
  include BookmarkableAssociation
  include PostableAssociation
  include ReservationLinkableAssociation
  include OpeningHourableAssociation
  include PageShowableAssociation
  include CommonListingScope

  def to_param
    slug
  end
end

# == Schema Information
#
# Table name: ski_areas
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
#  index_ski_areas_on_name             (name) UNIQUE
#  index_ski_areas_on_organization_id  (organization_id)
#  index_ski_areas_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
