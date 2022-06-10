class HotelUpdateForm
  include ActiveModel::Model

  attr_accessor :hotel, :district_id, :reservation_link

  validates :district_id, presence: true

  def initialize(hotel, params = {})
    @hotel = hotel

    self.district_id = @hotel.district_ids
    self.reservation_link = @hotel.reservation_link

    super params
  end

  def hotel_attributes=(attributes)
    @hotel.assign_attributes(attributes)
  end

  def reservation_link_attributes=(attributes)
    reservation_link.assign_attributes(attributes)
  end

  def update
    build_asscociations

    return false unless valid?

    ActiveRecord::Base.transaction do
      hotel.save!
      reservation_link.save!
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_asscociations
    @hotel.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [@hotel.valid?, reservation_link.valid?].all?
  end
end
