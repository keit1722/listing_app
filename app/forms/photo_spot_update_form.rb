class PhotoSpotUpdateForm
  include ActiveModel::Model

  attr_accessor :photo_spot, :opening_hours, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(photo_spot, params = {})
    @photo_spot = photo_spot

    self.district_id = @photo_spot.district_ids
    self.reservation_link = @photo_spot.reservation_link
    self.opening_hours = @photo_spot.opening_hours.early

    super params
  end

  def photo_spot_attributes=(attributes)
    @photo_spot.assign_attributes(attributes)
  end

  def opening_hours_attributes=(attributes)
    attributes.each do |k, attribute|
      opening_hours[k.to_i].assign_attributes(attribute)
    end
  end

  def reservation_link_attributes=(attributes)
    reservation_link.assign_attributes(attributes)
  end

  def update
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction do
      photo_spot.save!
      reservation_link.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    @photo_spot.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [
      @photo_spot.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
