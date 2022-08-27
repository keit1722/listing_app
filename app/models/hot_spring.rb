class HotSpring < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :organization

  include Districtable
  include Bookmarkable
  include Postable
  has_many :opening_hours, as: :opening_hourable, dependent: :destroy

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

  scope :search_with_district,
        lambda { |district_ids|
          joins(:districts).where(districts: { id: district_ids })
        }

  scope :keyword_contain,
        lambda { |keyword|
          where(
            [
              'description LIKE(?) OR Hot_springs.name LIKE(?)',
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
# Table name: hot_springs
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
#  index_hot_springs_on_name             (name) UNIQUE
#  index_hot_springs_on_organization_id  (organization_id)
#  index_hot_springs_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
