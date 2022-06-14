class RestaurantCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :restaurant,
                :opening_hours,
                :district_id,
                :restaurant_category_ids,
                :reservation_link

  validates :district_id, presence: true
  validates :restaurant_category_ids, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.restaurant = organization.restaurants.build unless restaurant.present?
    self.district_id = params[:district_id]
    self.restaurant_category_ids =
      params[:restaurant_category_ids]&.reject(&:empty?)
    self.reservation_link = ReservationLink.new unless reservation_link.present?
    self.opening_hours =
      DAY_COUNT.times.map { OpeningHour.new } unless opening_hours.present?
  end

  def restaurant_attributes=(attributes)
    self.restaurant = @organization.restaurants.build(attributes)
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
      restaurant.save!
      reservation_link.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associationss
    restaurant.district_ids = district_id.to_i unless district_id.empty?
    restaurant.restaurant_category_ids =
      restaurant_category_ids.reject(&:empty?)&.map(&:to_i)
    reservation_link.reservation_linkable = restaurant
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = restaurant
    end
  end

  def valid?
    super
    [
      restaurant.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
