class PhotoSpotCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :photo_spot, :opening_hours, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.photo_spot = organization.photo_spots.build if photo_spot.blank?
    self.district_id = params[:district_id]
    self.reservation_link = ReservationLink.new if reservation_link.blank?
    return if opening_hours.present?

    self.opening_hours = Array.new(DAY_COUNT) { OpeningHour.new }
  end

  def photo_spot_attributes=(attributes)
    self.photo_spot = @organization.photo_spots.build(attributes)
  end

  def opening_hours_attributes=(attributes)
    self.opening_hours =
      attributes.map do |_, opening_hours_attributes|
        OpeningHour.new(opening_hours_attributes)
      end
  end

  def reservation_link_attributes=(attributes)
    self.reservation_link = ReservationLink.new(attributes)
  end

  def save
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
    photo_spot.district_ids = district_id.to_i unless district_id.empty?
    reservation_link.reservation_linkable = photo_spot
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = photo_spot
    end
  end

  def valid?
    super
    [
      photo_spot.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
