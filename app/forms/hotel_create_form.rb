class HotelCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :hotel, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.hotel = organization.hotels.build unless hotel.present?
    self.district_id = params[:district_id]
    self.reservation_link = ReservationLink.new unless reservation_link.present?
  end

  def hotel_attributes=(attributes)
    self.hotel = @organization.hotels.build(attributes)
  end

  def reservation_link_attributes=(attributes)
    self.reservation_link = ReservationLink.new(attributes)
  end

  def save
    build_associationss

    return false unless valid?

    ActiveRecord::Base.transaction do
      hotel.save!
      reservation_link.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    hotel.district_ids = district_id.to_i unless district_id.empty?
    reservation_link.reservation_linkable = hotel
  end

  def valid?
    super
    [hotel.valid?, reservation_link.valid?].all?
  end
end
