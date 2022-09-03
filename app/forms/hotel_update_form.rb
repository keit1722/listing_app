class HotelUpdateForm
  include ActiveModel::Model

  attr_accessor :hotel, :district_id, :reservation_link, :opening_hours

  validates :district_id, presence: true

  def initialize(hotel, params = {})
    @hotel = hotel

    self.district_id = @hotel.district_ids
    self.reservation_link = @hotel.reservation_link
    self.opening_hours = @hotel.opening_hours.early

    super params
  end

  def hotel_attributes=(attributes)
    @hotel.assign_attributes(attributes)
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
      hotel.save!
      reservation_link.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    @hotel.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [
      @hotel.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
