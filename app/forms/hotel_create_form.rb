class HotelCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :hotel,
                :district_id,
                :reservation_link,
                :opening_hours,
                :page_show

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.hotel = organization.hotels.build if hotel.blank?
    self.district_id = params[:district_id]
    self.reservation_link = ReservationLink.new if reservation_link.blank?
    self.page_show = PageShow.new if page_show.blank?
    return if opening_hours.present?

    self.opening_hours = Array.new(DAY_COUNT) { OpeningHour.new }
  end

  def hotel_attributes=(attributes)
    self.hotel = @organization.hotels.build(attributes)
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

  def page_show_attributes=(attributes)
    self.page_show = PageShow.new(attributes)
  end

  def save
    build_associations

    return false unless valid?

    ActiveRecord::Base.transaction do
      hotel.save!
      reservation_link.save!
      page_show.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associations
    hotel.district_ids = district_id.to_i unless district_id.empty?
    reservation_link.reservation_linkable = hotel
    page_show.page_showable = hotel
    opening_hours.each { |opening_hour| opening_hour.opening_hourable = hotel }
  end

  def valid?
    super
    [
      hotel.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?
    ].all?
  end
end
