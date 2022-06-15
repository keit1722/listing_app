class PhotoSpotUpdateForm
  include ActiveModel::Model

  attr_accessor :photo_spot, :district_id

  validates :district_id, presence: true

  def initialize(photo_spot, params = {})
    @photo_spot = photo_spot

    self.district_id = @photo_spot.district_ids

    super params
  end

  def photo_spot_attributes=(attributes)
    @photo_spot.assign_attributes(attributes)
  end

  def update
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction { photo_spot.save! }
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    @photo_spot.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    @photo_spot.valid?
  end
end
