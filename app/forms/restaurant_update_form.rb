class RestaurantUpdateForm
  include ActiveModel::Model

  attr_accessor :restaurant,
                :opening_hours,
                :district_id,
                :restaurant_category_ids,
                :reservation_link,
                :page_show

  validates :district_id, presence: true
  validates :restaurant_category_ids, presence: true

  def initialize(restaurant, params = {})
    @restaurant = restaurant

    self.district_id = @restaurant.district_ids
    self.restaurant_category_ids = @restaurant.restaurant_category_ids
    self.reservation_link = @restaurant.reservation_link
    self.opening_hours = @restaurant.opening_hours.early
    self.page_show = @restaurant.page_show

    super params
  end

  def restaurant_attributes=(attributes)
    @restaurant.assign_attributes(attributes)
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
    @restaurant.district_ids = district_id.to_i unless district_id.empty?
    @restaurant.restaurant_category_ids =
      restaurant_category_ids.reject(&:empty?)&.map(&:to_i)
  end

  def valid?
    super
    [
      @restaurant.valid?,
      reservation_link.valid?,
      page_show.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end
