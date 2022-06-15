class PhotoSpotCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :photo_spot, :district_id

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.photo_spot = organization.photo_spots.build if photo_spot.blank?
    self.district_id = params[:district_id]
  end

  def photo_spot_attributes=(attributes)
    self.photo_spot = @organization.photo_spots.build(attributes)
  end

  def save
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction { photo_spot.save! }
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    photo_spot.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    photo_spot.valid?
  end
end
