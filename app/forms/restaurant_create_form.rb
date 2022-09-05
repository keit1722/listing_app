class RestaurantCreateForm
  include ActiveModel::Model

  DAY_COUNT = 8

  attr_accessor :restaurant,
                :opening_hours,
                :district_id,
                :restaurant_category_ids,
                :reservation_link,
                :page_show

  validates :district_id, presence: true
  validates :restaurant_category_ids, presence: true

  def initialize(organization, params = {})
    @organization = organization
    super params

    self.restaurant = organization.restaurants.build if restaurant.blank?
    self.district_id = params[:district_id]
    self.restaurant_category_ids =
      params[:restaurant_category_ids]&.reject(&:empty?)
    self.reservation_link = ReservationLink.new if reservation_link.blank?
    self.page_show = PageShow.new if page_show.blank?
    return if opening_hours.present?

    self.opening_hours = Array.new(DAY_COUNT) { OpeningHour.new }
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

  def page_show_attributes=(attributes)
    self.page_show = PageShow.new(attributes)
  end

  def save
    build_associations

    return false unless valid?

    ActiveRecord::Base.transaction do
      restaurant.save!
      reservation_link.save!
      page_show.save!
      opening_hours.each(&:save!)
    end
  rescue ActiveRecord::RecordInvalid
    false
  end

  private

  def build_associations
    restaurant.district_ids = district_id.to_i unless district_id.empty?
    restaurant.restaurant_category_ids =
      restaurant_category_ids.reject(&:empty?)&.map(&:to_i)
    reservation_link.reservation_linkable = restaurant
    page_show.page_showable = restaurant
    opening_hours.each do |opening_hour|
      opening_hour.opening_hourable = restaurant
    end
  end

  def valid?
    super
    [
      restaurant.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
