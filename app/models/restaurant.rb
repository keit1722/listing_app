class Restaurant < ApplicationRecord
  include ActiveModel::Validations

  belongs_to :organization

  include Districtable
  include Bookmarkable
  include Postable
  has_many :restaurant_category_mappings, dependent: :destroy
  has_many :restaurant_categories, through: :restaurant_category_mappings
  has_one :reservation_link, as: :reservation_linkable, dependent: :destroy
  has_many :opening_hours, as: :opening_hourable, dependent: :destroy
  has_one :page_show, as: :page_showable, dependent: :destroy

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

  scope :search_with_category,
        lambda { |category_ids|
          joins(:restaurant_categories).where(
            restaurant_categories: {
              id: category_ids,
            },
          )
        }

  include CommonListingScope

  def to_param
    slug
  end
end

# == Schema Information
#
# Table name: restaurants
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
#  index_restaurants_on_name             (name) UNIQUE
#  index_restaurants_on_organization_id  (organization_id)
#  index_restaurants_on_slug             (slug) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
