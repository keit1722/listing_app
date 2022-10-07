class HotelUpdateForm
  include ActiveModel::Model

  attr_accessor :hotel,
                :district_id,
                :reservation_link,
                :opening_hours,
                :page_show

  validates :district_id, presence: true

  def initialize(hotel, params = {})
    @hotel = hotel

    self.district_id = @hotel.district_ids
    self.reservation_link = @hotel.reservation_link
    self.opening_hours = @hotel.opening_hours.early
    self.page_show = @hotel.page_show

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

  def page_show_attributes=(attributes)
    page_show.assign_attributes(attributes)
  end

  def update
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
    @hotel.district_ids = district_id.to_i unless district_id.empty?
  end

  def valid?
    super
    [
      @hotel.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?
    ].all?
  end
end
