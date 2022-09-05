class PhotoSpot < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :organization

  include Districtable
  include Bookmarkable
  include Postable
  include ReservationLinkable
  include OpeningHourable
  include PageShowable

  has_one_attached :main_image
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
  validates :main_image, attached: true, content_type: %i[png jpg jpeg]
  validates :images, limit: { max: 4 }, content_type: %i[png jpg jpeg]

  include CommonListingScope

  def to_param
    slug
  end
end

# == Schema Information
#
# Table name: photo_spots
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
#  index_photo_spots_on_name             (name) UNIQUE
#  index_photo_spots_on_organization_id  (organization_id)
#  index_photo_spots_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
