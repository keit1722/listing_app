class RestaurantUpdateForm
  include ActiveModel::Model

  attr_accessor :restaurant,
                :opening_hours,
                :district_id,
                :restaurant_category_ids,
                :reservation_link

  validates :district_id, presence: true
  validates :restaurant_category_ids, presence: true

  def initialize(restaurant, params = {})
    @restaurant = restaurant

    self.district_id = @restaurant.district_ids
    self.restaurant_category_ids = @restaurant.restaurant_category_ids
    self.reservation_link = @restaurant.reservation_link
    self.opening_hours = @restaurant.opening_hours.early

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

  def update
    build_asscociations

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

  def build_asscociations
    @restaurant.district_ids = district_id.to_i unless district_id.empty?
    @restaurant.restaurant_category_ids =
      restaurant_category_ids.reject(&:empty?)&.map(&:to_i)
  end

  def valid?
    super
    [
      @restaurant.valid?,
      reservation_link.valid?,
      opening_hours.map(&:valid?).all?,
    ].all?
  end
end