class SkiArea < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :organization

  include Districtable
  include Bookmarkable
  include Postable
  has_many :opening_hours, as: :opening_hourable, dependent: :destroy
  has_one :page_show, as: :page_showable, dependent: :destroy

  has_many_attached :images
  has_one_attached :main_image

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

  scope :search_with_district,
        lambda { |district_ids|
          joins(:districts).where(districts: { id: district_ids })
        }

  scope :keyword_contain,
        lambda { |keyword|
          where(
            [
              'description LIKE(?) OR Ski_areas.name LIKE(?)',
              "%#{keyword}%",
              "%#{keyword}%",
            ],
          )
        }

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
